#!/usr/bin/env python3
# checks that js/asm.js produces exactly the same code as python/asm.py
# for every asm/*.asm file (with the opcodes of the machine named in the file: *_mkN*.asm)
import glob, os, re, shutil, subprocess, sys
ROOT = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'python'))
import asm  # noqa: E402

if not shutil.which('node'):
    print('node not found - asm parity check skipped'); sys.exit(0)
n_ok = n_fail = n_err = 0
for path in sorted(glob.glob(os.path.join(ROOT, 'asm', '*.asm'))):
    m = re.search(r'_(mk\d+)', os.path.basename(path))
    opc = os.path.join(ROOT, 'nim', f'{m.group(1)}_opcodes.nim') if m else None
    if not opc or not os.path.exists(opc):
        opc = os.path.join(ROOT, 'nim', 'mk1_opcodes.nim')
    try:
        py = asm.compile(open(path).read(), asm.get_opcodes_from_text(open(opc).read()))
        py_err = None
    except Exception as e:
        py, py_err = None, str(e)
    p = subprocess.run(['node', os.path.join(ROOT, 'js', 'asm.js'), opc, path], capture_output=True, text=True)
    js = [int(t) for t in p.stdout.split()] if p.returncode == 0 else None
    if py is None and js is None:
        n_err += 1  # both reject the file (ie old/broken sources) - still consistent
    elif py == js:
        n_ok += 1
    else:
        n_fail += 1
        print(f'FAIL asm parity {os.path.relpath(path, ROOT)}: python={"error: "+py_err if py is None else len(py)} js={p.stderr.strip()[-120:] if js is None else len(js)}')
print(f'asm.js parity: {n_ok} identical, {n_err} rejected by both, {n_fail} different')
sys.exit(1 if n_fail else 0)
