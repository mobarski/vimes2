# simple, universal assembler for p-code

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
