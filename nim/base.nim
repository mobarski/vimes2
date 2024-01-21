import parseutils
import strutils

type Cell = int16
const STACK_SIZE = 1000

var p : Cell # program counter
var b : Cell # base pointer
var t : Cell # top of stack pointer

var s : array[STACK_SIZE, Cell] # stack

proc base(level: Cell) : Cell =
    var b1 = b
    var l = level
    while l > 0:
        b1 = s[b1]
        l = l - 1
    return b1

proc reset(quick=false) =
    p=0; b=0; t=0
    if quick: return
    for j in low(s)..high(s):
        s[j] = 0

# TODO: rename (canditates: debug, trace, dump, show)
proc debug() =
    echo "p:", p, " b:", b, " t:", t, " s:", s[1..t]

proc code_from_hex(text:string) = 
    for i in countup(0, text.len-1, 4):
        var v : int
        let n = parse_hex(text, v, i, 4)
        assert n == 4
        echo i,' ',n,' ',v#,' ',v.int16

#code_from_hex("FF000011")
