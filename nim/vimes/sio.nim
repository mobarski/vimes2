import parseutils

var buffer: string
var pos: int = 1
var eof*: bool

proc read_int*(): int =
    while true:
        if pos >= buffer.len:
            if not stdin.read_line(buffer):
                eof = true
                return -1
            pos = 0
        if buffer.len == 0: continue
        pos += skip_whitespace(buffer, pos)
        if pos >= buffer.len: continue
        let n = parse_int(buffer, result, pos)
        if n > 0:
            pos += n
            break

proc read_chr*(): int =
    while true:
        if pos > buffer.len:
            if not stdin.read_line(buffer):
                eof = true
                return -1
            pos = 0
        if pos == buffer.len:
            pos += 1
            return 10
        if buffer.len == 0:
            pos += 1
            return 10
        result = buffer[pos].int
        pos += 1
        return


if is_main_module:
    for i in 1..5:
        echo read_chr()
