import parseutils

var line_buffer: string
var line_buffer_pos: int
var eof*: bool
proc read_int*() : int =
    while true:
        if line_buffer_pos >= line_buffer.len:
            if not stdin.read_line(line_buffer):
                eof = true
                return -1
            line_buffer_pos = 0
        if line_buffer.len == 0: continue
        line_buffer_pos += skip_whitespace(line_buffer, line_buffer_pos)
        if line_buffer_pos >= line_buffer.len: continue
        let n = parse_int(line_buffer, result, line_buffer_pos)
        if n > 0:
            line_buffer_pos += n
            break

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
