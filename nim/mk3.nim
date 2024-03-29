# mk3: bytecode, variable number of arguments, a and l swapped

type Word = int16
const STACK_SIZE = 1000

include mk1_opcodes

var p : Word # program counter
var b : Word # base pointer
var t : Word # top of stack pointer

var s : array[STACK_SIZE, Word] # stack

proc base(level: Word) : Word =
    var b1 = b
    var l = level
    while l > 0:
        b1 = s[b1]
        l = l - 1
    return b1

# THIS WON'T WORK NOW AS WE CHANGED run(code) to run() and code is from base.nim
proc run(code : openArray[int8]) =
    while true:
        var i = code[p+0].Word
        var a = code[p+1].Word
        var l : Word # not always used
        p += 2

        case i:
            of LIT: t+=1; s[t]=a
            of LOD:
                l = code[p].Word; p+=1
                t+=1; s[t]=s[base(l)+a]
            of STO:
                l = code[p].Word; p+=1
                s[base(l)+a]=s[t]; t-=1
            of INT: t+=a
            of JMP: p=a
            of JPC:
                if s[t]==0:
                    p = a
                    t -= 1
            of CAL:
                l = code[p].Word; p+=1
                s[t+1] = base(l)
                s[t+2] = b
                s[t+3] = p
                b = t + 1
                p = a
            of OPR:
                case a:
                    of RET: t=b-1; p=s[t+3]; b=s[t+2]
                    of ADD: t-=1; s[t] += s[t+1]
                    of SUB: t-=1; s[t] -= s[t+1]
                    of MUL: t-=1; s[t] *= s[t+1]
                    of DIV: t-=1; s[t] =  s[t] div s[t+1]
                    of MOD: t-=1; s[t] =  s[t] mod s[t+1]
                    of ODD:       s[t] =  s[t] mod 2
                    of NEG:       s[t] = -s[t]
                    of EQ:  t-=1; s[t] = (s[t] == s[t+1]).ord.Word
                    of NE:  t-=1; s[t] = (s[t] != s[t+1]).ord.Word
                    of LT:  t-=1; s[t] = (s[t] <  s[t+1]).ord.Word
                    of LE:  t-=1; s[t] = (s[t] <= s[t+1]).ord.Word
                    of GT:  t-=1; s[t] = (s[t] >  s[t+1]).ord.Word
                    of GE:  t-=1; s[t] = (s[t] >= s[t+1]).ord.Word
                    else: quit("unknown OPR opcode",1)
            #
            of LIT2:
                a = a shl 8 or code[p].Word; p+=1
                t+=1; s[t]=a
            of JMP2:
                a = a shl 8 or code[p].Word; p+=1
                p = a
            of JPC2:
                a = a shl 8 or code[p].Word; p+=1
                if s[t]==0:
                    p = a
                    t -= 1
            of CAL2:
                a = a shl 8 or code[p].Word; p+=1
                l = code[p].Word; p+=1
                s[t+1] = base(l)
                s[t+2] = b
                s[t+3] = p
                b = t + 1
                p = a
            else: quit("unknown opcode",1)

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

const vm_code = [
    INT.int8, 0, # nop
    LIT2, 0, 11,
    LIT2, 0, 22,
    OPR, ADD,
    OPR, NEG,
    LIT, -9,
    OPR, ADD,
    JMP2, 0, 0 # halt
]
run(vm_code)
debug()
reset(quick=true)
run(vm_code)
debug()
