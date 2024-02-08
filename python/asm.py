#!/usr/bin/env python3
# simple, one-file, universal assembler for p-code

# === CORE ====================================================================

import re

CFG = {
    'line_comment': [';','#','--'],
    'inline_comment_re': r'\(.*?\)', # TODO: multiple
    'ignored_tokens': [',','|'],
    'kv_separator': '=',
    'case_insensitive': True,
    'force_opcodes_case':0, # -1:lower 1:upper
}

def compile(text, opcodes: dict[str,int]) -> list[int]:
    """compile text into p-code
    converts opcode names to numbers
    converts python integer literals  (ie. `1_234`) to plain numbers
    converts labels to addresses
    - `name:` to define label
    - `name`  to insert label's address
    converts keys to values
    - `key:value` to define key-value pair
    - `key`       to insert value (number or instruction)
    """
    if CFG['force_opcodes_case']==-1:
        opcodes = {k.lower():v for k,v in opcodes.items()}
    if CFG['force_opcodes_case']==1:
        opcodes = {k.upper():v for k,v in opcodes.items()}
    if CFG['case_insensitive']:
        text = text.lower()
        opcodes = {k.lower():v for k,v in opcodes.items()}
    lines = text.split('\n')
    # first pass - collect labels
    label = {} # label_name -> label_pos
    tokens = []
    n_ignored = 0
    kv = {}
    for line in lines:
        # remove inline comments
        line = re.sub(CFG['inline_comment_re'], '', line)
        # split into tokens
        line_tokens = re.split('\\s+',line)
        # process tokens
        break_outer = False
        for token in line_tokens:
            if not token: continue
            # comments
            for line_comment in CFG['line_comment']:
                if token.startswith(line_comment):
                    break_outer = True
                    break
            if break_outer: break
            # labels
            if token[-1]==':':
                name = token[:-1]
                label[name] = len(tokens)
            # kv
            elif CFG['kv_separator'] in token:
                k,_,v = token.partition(CFG['kv_separator'])
                if v in opcodes:
                    kv[k] = opcodes[v]
                else:
                    kv[k] = int(v)
            else:
                tokens += [token]
    # second pass - all labels are known
    out = []
    for token in tokens:
        # label use
        if token in label:
            pos = label[token]
            out += [pos]
        # opcodes
        elif token in opcodes:
            out += [opcodes[token]]
        # kv use
        elif token in kv:
            out += [kv[token]]
        # ignored
        elif token in CFG['ignored_tokens']:
            pass
        # numbers
        else:
            try:
                out += [int(token)]
                continue
            except:
                raise Exception(f'Unknown token "{token}"')
    return out

# === CLI =====================================================================

import argparse
import binascii
import struct
import sys

def get_opcodes_from_text(text: str) -> dict[str,int]:
    opcodes = {}
    opcode_re = re.compile(r'([A-Z][A-Z0-9_]*)\s*[:=]*\s*(\d+)')
    #comment_re = re.compile(r'#.*')
    #text = text.lower()
    for line in text.split('\n'):
        #line = comment_re.sub('', line)
        line = line.strip()
        if not line: continue
        match = opcode_re.findall(line)
        for name, value in match:
            opcodes[name] = int(value)
    return opcodes

def cli():
    # configure parser
    parser = argparse.ArgumentParser(description='Vimes tiny p-code assembler')
    parser.add_argument('opcodes_path',        help='opcodes file path', type=str)
    parser.add_argument('asm_path',            help='input file path',   type=str)
    parser.add_argument('-v', dest='verbose',  help='verbose output',  action='store_true')
    parser.add_argument('-o', dest='out_path', help='output file path (default: a.out)',         type=str, default='a.out')
    parser.add_argument('-f', dest='format',   help='output format: bin|hex|b10|b16 (default: bin)', type=str, default='bin')
    
    # parse args
    args = parser.parse_args()
    if args.verbose:
        eprint('args:', args, '', sep='\n')
    
    # read input
    asm_text = open(args.asm_path).read()
    opc_text = open(args.opcodes_path).read()
    opcodes = get_opcodes_from_text(opc_text)
    if args.verbose:
        eprint('opcodes:', opcodes, '', sep='\n')
    
    # compile asm
    pcode = compile(asm_text, opcodes)
    if args.verbose:
        eprint('pcode:', pcode, '', sep='\n')
    
    # write output
    if args.verbose:
        eprint('out_path:', args.out_path, '', sep='\n')
        eprint('format:', args.format, '', sep='\n')
    #
    if args.out_path == '-':
        out_file = sys.stdout
    elif args.format == 'bin':
        out_file = open(args.out_path, 'wb')
    else:
        out_file = open(args.out_path, 'w')
    #
    BYTEORDER='!'
    TYPECODE='h'
    if args.format=='bin':
        a = struct.pack(f'{BYTEORDER}{len(pcode)}{TYPECODE}', *pcode)
        out_file.write(a)
    elif args.format=='hex':
        a = struct.pack(f'{BYTEORDER}{len(pcode)}{TYPECODE}', *pcode)
        out_file.write(binascii.hexlify(a).decode())
    elif args.format=='b16':
        output = ' '.join([f"{x:x}" for x in pcode])
        out_file.write(output)
    elif args.format=='b10':
        output = ' '.join([str(x) for x in pcode])
        out_file.write(output)
    else:
        raise Exception(f'Unknown format "{args.format}"')
    out_file.close()

def eprint(*a, **kw):
    print(*a, file=sys.stderr, **kw)

if __name__ == "__main__":
    cli()
