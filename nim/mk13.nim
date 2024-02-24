# mk6: register-based vm inspired by Smol

import strformat
import vimes/sio
import vimes/load
import bench

include mk13_opcodes
include mk13_opnames
type Word = int16

var pc: Word # program counter
var sp: Word # stack pointer
var acc: Word # accumulator
var cc: int64 # used only when -d:cc is passed
var mem:   seq[Word] = @[] # memory
var stack: seq[Word] = @[] # return stack
var code:  seq[Word] = @[] # program

proc reset(quick=false) =
    pc=0; sp=0; cc=0; acc=0
    if quick: return
    for j in low(mem)..high(mem):
        mem[j] = 0
    for j in low(stack)..high(stack):
        stack[j] = 0

proc trace(op,a,b:Word) =
    let opname = opnames[cast[Instr](op)]
    let va = mem[a]
    let vb = mem[b]
    stderr.write_line """| {cc:3} | {pc:2} | {acc:2} | {opname:>4} {a:2} {b:2} | {va:3} | {vb:3} | """.fmt

proc debug() =
    echo "pc:", pc, " sp:", sp, " cc:", cc

proc run() =
    while true:
        let opc = code[pc]
        let op = cast[Instr]( opc )
        let a = code[pc+1]
        let b = code[pc+2]
        
        when defined(cc):    cc+=1
        when defined(trace): trace(opc,a,b)

        pc += 3
        case op:
            # control flow
            of JZ:
                if acc==0: pc=a # b is ignored
            of JNZ:
                if acc!=0: pc=a # b is ignored
            of CAL:  stack[sp]=pc; sp+=1; pc=a # b is ignored
            of RET:  sp-=1; pc=stack[sp]       # a and b are ignored
            of JMP:  pc=a                      # b is ignored
            # memory
            of LIT:  mem[a] = b
            of MOV:  mem[a] = mem[b]
            of LDA:  acc = mem[a] # b is ignored
            of LDAP: acc = mem[mem[a]+mem[b]]
            of STA:  mem[a] = acc # b is ignored
            of STAP: mem[mem[a]+mem[b]] = acc
            # alu
            of ADD:  mem[a] = mem[a] + mem[b]
            of SUB:  mem[a] = mem[a] - mem[b]
            of MUL:  mem[a] = mem[a] * mem[b]
            of DIV:  mem[a] = mem[a] div mem[b]
            of MOD:  mem[a] = mem[a] mod mem[b]
            of NEG:  mem[a] = -mem[a] # b is ignored
            # cmp
            of EQ:   acc = (mem[a] == mem[b]).ord.Word
            of NE:   acc = (mem[a] != mem[b]).ord.Word
            of LT:   acc = (mem[a] <  mem[b]).ord.Word
            of LE:   acc = (mem[a] <= mem[b]).ord.Word
            of GT:   acc = (mem[a] >  mem[b]).ord.Word
            of GE:   acc = (mem[a] >= mem[b]).ord.Word
            # stdio
            of PUT : echo mem[a]                   # b is ignored
            of GET : mem[a] = sio.read_int().Word  # b is ignored
            of EOF:  mem[a] = sio.eof.ord.Word     # b is ignored
            of GETC: mem[a] = sio.read_chr().Word  # b is ignored
            of PUTC: echo mem[a].char              # b is ignored
            # misc
            of HLT:  break
            else:
                quit("unknown opcode op:" & $op, 1)

include cli
if is_main_module:
    cli()
