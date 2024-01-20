#!/usr/bin/env python3
# simple, universal assembler for p-code

# === CORE ====================================================================

import re

def compile(text, opcodes: dict[str,int]) -> list[int]:
    """compile text into p-code
    converts opcode names to numbers
    converts python integer literals  (ie. `1_234`) to plain numbers
    treats `;` as line comment start
    converts labels to addresses
    - `name:` to define label
    - `name`  to insert label's absolute address
    - `@name` to insert label's relative address
    """
    lines = text.split('\n')
    # first pass - collect labels
    label = {}
    tokens = []
    for line in lines:
        line_tokens = re.split('\\s+',line)
        for token in line_tokens:
            if not token: continue
            # comments
            if token[0]==';': break
            # labels
            elif token[-1]==':':
                name = token[:-1]
                label[name] = len(tokens)
            else:
                tokens += [token]
    # second pass - all labels are known
    out = []
    for token in tokens:
        # label use
        if token[0]=='@':
            # relative
            name = token[1:]
            pos = label[name]
            offset = pos - len(out) + 1
            out += [offset]
        elif token in label:
            # absolute
            pos = label[token]
            out += [pos]
        # opcodes
        elif token in opcodes:
            out += [opcodes[token]]
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
import array

def get_opcodes_from_text(text: str) -> dict[str,int]:
    opcodes = {}
    opcode_re = re.compile(r'(\w+)\s*[:=]*\s*(\d+)')
    comment_re = re.compile(r'#.*')
    for line in text.split('\n'):
        line = comment_re.sub('', line)
        line = line.strip()
        if not line: continue
        match = opcode_re.findall(line)
        for name, value in match:
            opcodes[name] = int(value)
    return opcodes

def cli():
    # configure parser
    parser = argparse.ArgumentParser(
        prog='asm.py',
        description='Compile p-code assembler')
    parser.add_argument('opcodes_path',        help='opcodes file path', type=str)
    parser.add_argument('asm_path',            help='input file path',   type=str)
    parser.add_argument('-v', dest='verbose',  help='verbose output',  action='store_true')
    parser.add_argument('-o', dest='out_path', help='output file path (default: a.out)', type=str, default='a.out')
    parser.add_argument('-f', dest='format',   help='output format: TODO',               type=str, default='')
    # parse args
    args = parser.parse_args()
    if args.verbose:
        print('args:', args, '', sep='\n')
    # read input
    asm_text = open(args.asm_path).read()
    opc_text = open(args.opcodes_path).read()
    opcodes = get_opcodes_from_text(opc_text)
    if args.verbose:
        print('opcodes:', opcodes, '', sep='\n')
    # compile asm
    pcode = compile(asm_text, opcodes)
    if args.verbose:
        print('pcode:', pcode, '', sep='\n')
    # write output
    if args.verbose:
        print('out_path:', args.out_path, '', sep='\n')
    with open(args.out_path, 'wb') as out_file:
        out_file.write(array.array('h', pcode).tobytes())

if __name__ == "__main__":
    cli()
