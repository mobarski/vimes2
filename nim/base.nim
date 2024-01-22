import parseutils
import strutils

type Cell = int16
const STACK_SIZE = 1000

var p : Cell # program counter
var b : Cell # base pointer
var t : Cell # top of stack pointer
var s : array[STACK_SIZE, Cell] # stack

var cc : int64 # cycle counter

proc base(level: Cell) : Cell =
    var b1 = b
    var l = level
    while l > 0:
        b1 = s[b1]
        l = l - 1
    return b1

proc reset(quick=false) =
    p=0; b=0; t=0; cc=0
    if quick: return
    for j in low(s)..high(s):
        s[j] = 0

# TODO: rename (canditates: debug, trace, dump, show)
proc debug() =
    echo "p:",p, " b:",b, " t:",t, " cc:",cc, " s:",s[1..t]

proc code_from_hex(text:string) : seq[Cell] = 
    # TODO: allow whitespace
    for i in countup(0, text.len-1, 4):
        var v : int
        let n : int = parse_hex(text, v, i, 4)
        assert n == 4
        result.add cast[Cell](v)
