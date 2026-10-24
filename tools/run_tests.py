#!/usr/bin/env python3
# vimes2 test runner
# - reads tests/cases.txt (machine, asm file, oracle, input)
# - assembles programs with python/asm.py
# - runs every available backend (C variants, Nim, JS hook) for the machine
# - compares output with the oracle (tests/oracle.py) and with tests/expected/
# - checks cross-variant consistency: same output and same VM cycle count

import argparse
import json
import os
import re
import shutil
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'python'))
sys.path.insert(0, os.path.join(ROOT, 'tests'))
import asm     # noqa: E402
import oracle  # noqa: E402

# === MACHINES ================================================================
# backend = (name, kind, path relative to ROOT)

def c_backends(*names):   return [(n, 'c',   f'bin/{n}')           for n in names]
def nim_backends(*names): return [(f'{n}_nim', 'nim', f'bin/{n}_nim') for n in names]
def js_backends(*names):  return [(f'{n}_js',  'js',  f'js/{n}.js')   for n in names]

MACHINES = {
    'mk6':  dict(opcodes='nim/mk6_opcodes.nim',  backends=nim_backends('mk6')),
    'mk7':  dict(opcodes='nim/mk7_opcodes.nim',  backends=c_backends('mk7c', 'mk7ci', 'mk7cd') + nim_backends('mk7') + js_backends('mk7')),
    'mk8':  dict(opcodes='nim/mk8_opcodes.nim',  backends=c_backends('mk8c', 'mk8ci', 'mk8cd') + nim_backends('mk8') + js_backends('mk8')),
    'mk9':  dict(opcodes='nim/mk9_opcodes.nim',  backends=nim_backends('mk9')),
    'mk10': dict(opcodes='nim/mk10_opcodes.nim', backends=nim_backends('mk10')),
    'mk11': dict(opcodes='nim/mk11_opcodes.nim', backends=nim_backends('mk11')),
    'mk12': dict(opcodes='nim/mk12_opcodes.nim', backends=nim_backends('mk12')),
    'mk13': dict(opcodes='nim/mk13_opcodes.nim', backends=nim_backends('mk13') + js_backends('mk13')),
}

TIMEOUT = 30 # seconds per run

# === CASES ===================================================================

def read_cases(path):
    """line format: machine  asm_file  oracle  input...  (input: ints or @file)"""
    cases = []
    seen = {}
    for line_num, line in enumerate(open(path), 1):
        line = line.split('#')[0].strip()
        if not line: continue
        machine, asm_path, oracle_name, *inp = line.split()
        if len(inp) == 1 and inp[0].startswith('@'):
            inp_text = open(os.path.join(ROOT, inp[0][1:])).read()
        else:
            inp_text = ' '.join(inp)
        stem = os.path.splitext(os.path.basename(asm_path))[0]
        seen[stem] = seen.get(stem, 0) + 1
        cases.append(dict(
            id=f'{stem}__{seen[stem]}', line=line_num, machine=machine,
            asm=asm_path, oracle=oracle_name, input=inp_text,
            input_label=' '.join(inp) if len(' '.join(inp)) < 40 else ' '.join(inp)[:37] + '...',
        ))
    return cases

# === ASSEMBLY ================================================================

def assemble(asm_path, opcodes_path):
    asm_text = open(os.path.join(ROOT, asm_path)).read()
    opc_text = open(os.path.join(ROOT, opcodes_path)).read()
    pcode = asm.compile(asm_text, asm.get_opcodes_from_text(opc_text))
    out_dir = os.path.join(ROOT, 'build', 'pcode')
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, os.path.basename(asm_path) + '.b10')
    with open(out_path, 'w') as f:
        f.write(' '.join(map(str, pcode)))
    return out_path, len(pcode)

# === BACKENDS ================================================================

def run_backend(kind, exe, pcode_path, inp):
    """returns (output_tokens, cycles or None)"""
    if kind == 'c':
        cmd = [exe, pcode_path, '-b', '1']           # -b 1 -> cycles on stderr
    elif kind == 'nim':
        cmd = [exe, pcode_path, '-d']                # -d -> "pc:.. cc:N" on stdout
    elif kind == 'js':
        cmd = ['node', exe, pcode_path]              # hook for P2 (browser card)
    p = subprocess.run(cmd, input=inp, capture_output=True, text=True, timeout=TIMEOUT)
    stdout, stderr = p.stdout, p.stderr
    cycles = None
    if kind == 'c':
        m = re.search(r'total cycles: (\d+)', stderr)
        cycles = int(m.group(1)) if m else None
    elif kind == 'nim':
        m = re.search(r'^pc:.*cc:\s*(-?\d+).*$', stdout, re.M)
        if m:
            cycles = int(m.group(1))
            stdout = stdout[:m.start()]
    elif kind == 'js':
        m = re.search(r'cycles: (\d+)', stderr)
        cycles = int(m.group(1)) if m else None
    if p.returncode != 0:
        raise RuntimeError(f'exit code {p.returncode}: {stderr.strip()[-200:]}')
    return [int(t) for t in stdout.split()], cycles

def available(kind, path):
    full = os.path.join(ROOT, path)
    if kind == 'js':
        return os.path.exists(full) and shutil.which('node') is not None
    return os.path.exists(full) and os.access(full, os.X_OK)

# === MAIN ====================================================================

def short(xs, n=12):
    s = ' '.join(map(str, xs))
    return s if len(xs) <= n else ' '.join(map(str, xs[:n])) + f' ... ({len(xs)} items)'

def main():
    ap = argparse.ArgumentParser(description='vimes2 test runner')
    ap.add_argument('--cases', default=os.path.join(ROOT, 'tests', 'cases.txt'))
    ap.add_argument('--machine', help='only this machine (ie mk8)')
    ap.add_argument('--backend', help='only this backend kind: c|nim|js')
    ap.add_argument('--write-expected', action='store_true', help='write tests/expected/*.txt from the oracle')
    ap.add_argument('-v', dest='verbose', action='store_true')
    args = ap.parse_args()

    cases = read_cases(args.cases)
    if args.machine:
        cases = [c for c in cases if c['machine'] == args.machine]

    exp_dir = os.path.join(ROOT, 'tests', 'expected')
    n_pass = n_fail = n_skip = n_cons_fail = 0
    skipped_backends = set()
    results = []
    for case in cases:
        m = MACHINES[case['machine']]
        expected = oracle.ORACLES[case['oracle']]([int(t) for t in case['input'].split()])
        # expected files (committed, human readable)
        exp_path = os.path.join(exp_dir, case['id'] + '.txt')
        if args.write_expected:
            os.makedirs(exp_dir, exist_ok=True)
            with open(exp_path, 'w') as f:
                f.write(' '.join(map(str, expected)) + '\n')
        elif os.path.exists(exp_path):
            file_exp = [int(t) for t in open(exp_path).read().split()]
            if file_exp != expected:
                print(f"FAIL {case['id']}: tests/expected differs from oracle (run make expected)")
                n_fail += 1
        pcode_path, code_len = assemble(case['asm'], m['opcodes'])
        runs = {}
        for name, kind, path in m['backends']:
            if args.backend and kind != args.backend: continue
            if not available(kind, path):
                skipped_backends.add(name); n_skip += 1
                continue
            try:
                out, cycles = run_backend(kind, os.path.join(ROOT, path), pcode_path, case['input'])
                err = None
            except Exception as e:
                out, cycles, err = None, None, str(e)
            ok = (err is None) and (out == expected)
            runs[name] = dict(kind=kind, ok=ok, cycles=cycles, error=err)
            if ok:
                n_pass += 1
                if args.verbose:
                    print(f"pass {case['id']:28} {name:9} cycles={cycles}")
            else:
                n_fail += 1
                print(f"FAIL {case['id']:28} {name:9} input: {case['input_label']}")
                print(f"     expected: {short(expected)}")
                print(f"     actual:   {short(out) if out is not None else err}")
        # cross-variant consistency (only among backends that produced output)
        cyc = {n: r['cycles'] for n, r in runs.items() if r['ok'] and r['cycles'] is not None}
        consistent = len(set(cyc.values())) <= 1
        if not consistent:
            n_cons_fail += 1
            print(f"FAIL {case['id']:28} cycle counts differ between variants: {cyc}")
        results.append(dict(case, expected=expected, code_words=code_len, runs=runs,
                            cycles=(list(cyc.values())[0] if cyc and consistent else None),
                            consistent=consistent))

    os.makedirs(os.path.join(ROOT, 'build'), exist_ok=True)
    with open(os.path.join(ROOT, 'build', 'results.json'), 'w') as f:
        json.dump(results, f, indent=1)

    print()
    print(f"cases: {len(cases)}  runs passed: {n_pass}  failed: {n_fail}  "
          f"skipped runs (backend not available): {n_skip}  consistency failures: {n_cons_fail}")
    if skipped_backends:
        print('skipped backends (not built / not available):', ' '.join(sorted(skipped_backends)))
    sys.exit(1 if (n_fail or n_cons_fail) else 0)

if __name__ == '__main__':
    main()
