import parseutils

proc code_from_hex*[T](text:string, width=4): seq[T] = 
    var pos = 0
    var val: int
    var n: int
    while pos < text.len:
        pos += skip_whitespace(text, pos)
        if pos >= text.len: break
        if text[pos] == '#':
            pos += skip_until(text, '\n', pos) + 1 # skip also the newline
            continue
        #
        n = parse_hex(text, val, pos, width)
        assert n == width, "invalid hex code at position " & $pos
        result.add cast[T](val)
        pos = pos + n

proc code_from_num*[T](text:string, base=10): seq[T] =
    assert base in {10,16}, "base not in {10,16}"
    var pos = 0
    var val: int
    var sign: int
    var n: int
    while pos < text.len:
        pos += skip_whitespace(text, pos)
        if pos >= text.len: break
        if text[pos] == '#':
            pos += skip_until(text, '\n', pos) + 1 # skip also the newline
            continue
        #
        if text[pos] == '-':
            sign = -1
            pos += 1
        else:
            sign = 1
        #
        case base:
            of 10: n = parse_int(text, val, pos)
            of 16: n = parse_hex(text, val, pos)
            else: assert false
        assert n > 0, "invalid number at position " & $pos
        result.add cast[T](val * sign)
        pos = pos + n

if is_main_module:
    echo code_from_hex[int16](" 00040005 00ff 1234 # 4321")
    echo code_from_num[int16](" 1 22 -33 444 # 555")
    echo code_from_num[int16](" 1 22 -33 444 # 555", base=16)
