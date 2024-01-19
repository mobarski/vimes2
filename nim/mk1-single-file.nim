# mk1: compatible with the original PL/0

type Cell = int16
const STACK_SIZE = 1000

const
    LIT = 1
    OPR = 2
    LOD = 3
    STO = 4
    CAL = 5
    INT = 6
    JMP = 7
    JPC = 8

const
    RET = 0
    NEG = 1
    ADD = 2
    SUB = 3
    MUL = 4
    DIV = 5
    ODD = 6
    MOD = 7
    EQ  = 8
    NE  = 9
    LT  = 10
    LE  = 11
    GT  = 12
    GE  = 13

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

proc run(code : openArray[int]) =
    while true:
        var i = code[p+0].Cell
        var l = code[p+1].Cell
        var a = code[p+2].Cell
        p += 3

        case i:
            of LIT: t+=1; s[t]=a
            of LOD: t+=1; s[t]=s[base(l)+a]
            of STO: s[base(l)+a]=s[t]; t-=1
            of INT: t+=a
            of JMP: p=a
            of JPC:
                if s[t]==0:
                    p = a
                    t -= 1
            of CAL:
                s[t+1] = base(l)
                s[t+2] = b
                s[t+3] = p
                b = t + 1
                p = a
            of OPR:
                case a:
                    of RET: t=b-1; p=s[t+3]; b=s[t+2]
                    of NEG: s[t] = -s[t]
                    of ADD: t-=1; s[t] += s[t+1]
                    of SUB: t-=1; s[t] -= s[t+1]
                    of MUL: t-=1; s[t] *= s[t+1]
                    of DIV: t-=1; s[t] = s[t] div s[t+1]
                    of ODD: s[t] = s[t] mod 2
                    of MOD: t-=1; s[t] = s[t] mod s[t+1]
                    of EQ:  t-=1; s[t] = ord(s[t] == s[t+1]).Cell
                    of NE:  t-=1; s[t] = ord(s[t] != s[t+1]).Cell
                    of LT:  t-=1; s[t] = ord(s[t] <  s[t+1]).Cell
                    of LE:  t-=1; s[t] = ord(s[t] <= s[t+1]).Cell
                    of GT:  t-=1; s[t] = ord(s[t] >  s[t+1]).Cell
                    of GE:  t-=1; s[t] = ord(s[t] >= s[t+1]).Cell
                    else: assert false
            else: assert false

        if p == 0: break

proc reset(quick=false) =
    p=0; b=0; t=0
    if quick: return
    for j in low(s)..high(s):
        s[j] = 0

# TODO: rename (canditates: debug, trace, dump, show)
proc debug() =
    echo "p:", p, " b:", b, " t:", t, " s:", s[1..t]

# ============================================================

const vm_code = @[
    INT, 0, 0, # nop
    LIT, 0, 11,
    LIT, 0, 22,
    OPR, 0, ADD,
    OPR, 0, NEG,
    LIT, 0, -9,
    OPR, 0, ADD,
    JMP, 0, 0, # halt
]
run(vm_code)
debug()
reset()
debug()
