import parseutils
import strutils
import strformat

type Word = int16
const STACK_SIZE = 1000

var p : Word # program counter
var b : Word # base pointer
var t : Word # top of stack pointer
var s : array[STACK_SIZE, Word] # stack
var code: seq[Word] # code

var cc : int64 # cycle counter

# instruction counter
when defined(ic):
    import tables
    import sequtils
    import algorithm

    var ic : Table[Word, int64]
    proc show_ic() =
        stderr.write_line ""
        stderr.write_line "+------+------+-----"
        stderr.write_line "| INST | PCT  | CNT  "
        stderr.write_line "+------+------+-----"
        var total = 0
        for k in ic.keys:
            total += ic[k]
        var keys = ic.keys.to_seq()
        keys.sort(proc(a,b:auto):int = cmp(ic[b],ic[a]))
        for k in keys:
            let pct = 100.0 * ic[k].float / total.float
            stderr.write_line "| {opnames[k]:>4} | {pct:>4.1f} | {ic[k]}".fmt

template base(level: Word) : Word =
    var b1 = b
    var l = level
    while l > 0:
        b1 = s[b1]
        l = l - 1
    b1 # "return" this

proc reset(quick=false) =
    p=0; b=0; t=0; cc=0
    if quick: return
    for j in low(s)..high(s):
        s[j] = 0

# TODO: rename (canditates: debug, trace, dump, show)
proc debug() =
    stderr.write_line "cc:",cc, " p:",p, " b:",b, " t:",t, " s:[ ",s[0..t].join(" ")," ]"

proc trace(a:Word, code:openArray[Word]) =
    let op = opnames.get_or_default(code[p], "???")
    stderr.write_line """| {cc:2} | {p:2} | {op:>4} {a:<4} | {b:2} | {t:2} | {s[1..t].join(" ")}""".fmt

proc trace_header() =
    stderr.write_line """+----+----+-----------+----+----+-------"""
    stderr.write_line """| CC |  P |    I A    |  B |  T | S --> """
    stderr.write_line """+----+----+-----------+----+----+-------"""

# proc code_from_hex(text:string) : seq[Word] = 
#     var pos = 0
#     var val : int
#     var n : int
#     while pos < text.len:
#         pos += skip_whitespace(text, pos)
#         if pos >= text.len: break
#         if text[pos] == '#':
#             pos += skip_until(text, '\n', pos) + 1 # skip also the newline
#             continue
#         #
#         n = parse_hex(text, val, pos, 4)
#         assert n == 4, "invalid hex code at position " & $pos
#         result.add cast[Word](val)
#         pos = pos + n
