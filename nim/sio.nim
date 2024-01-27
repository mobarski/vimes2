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

# TODO
#proc read_char*(): char =

# import sequtils
# import strutils
# proc parse_ints(text:string, base=10) : seq[int] =
#     var pos = 0
#     while pos < text.len:
#         var val = 0
#         var sign = 1
#         pos += skip_whitespace(text, pos)
#         pos += skip(text, "+", pos)
#         if skip(text, "-", pos) == 1:
#             sign = -1
#             pos += 1
#         var n = 0
#         case base:
#             of 10:
#                 n = parse_int(text, val, pos)
#             of 16:
#                 n = parse_hex(text, val, pos)
#             else:
#                 assert false, "invalid base" # TODO: better exception
#         if n == 0:
#             if pos < text.len:
#                 assert false, "invalid integer" # TODO: better exception
#             break
#         pos += n
#         result.add(val * sign)

if is_main_module:
    for i in 1..5:
        echo read_chr()
