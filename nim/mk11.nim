# mk6: register-based vm inspired by Smol

import strformat
import vimes/sio
import vimes/load
import bench

include mk11_opcodes
include mk11_opnames
type Word = int16

var pc: Word # program counter
var sp: Word # stack pointer
var cc: int64 # used only when -d:cc is passed
var acc: Word # accumulator
var mem:   seq[Word] = @[] # memory
var stack: seq[Word] = @[] # return stack
var code:  seq[Word] = @[] # program

proc reset(quick=false) =
    pc=0; sp=0; cc=0
    if quick: return
    for j in low(mem)..high(mem):
        mem[j] = 0
    for j in low(stack)..high(stack):
        stack[j] = 0

proc trace(op,a,b:Word) =
    let opname = opnames[cast[Instr](op)]
    let va = mem[a]
    let vb = mem[b]
    stderr.write_line """| {cc:3} | {pc:2} | {sp:2} | {opname:>4} {a:2} {b:2} | {va:3} | {vb:3} | """.fmt

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
                if mem[a]==0: pc=b
            of JNZ:
                if mem[a]!=0: pc=b
            of CAL:  stack[sp]=pc; sp+=1; pc=a # b is ignored
            of RET:  sp-=1; pc=stack[sp]       # a and b are ignored
            of JMP:  pc=a                      # b is ignored
            # memory
            of LIT:  mem[a] = b # rename to LOAD?
            of MOV:  mem[a] = mem[b]
            of PEEK: mem[a] = mem[mem[b]]
            of POKE: mem[mem[a]] = mem[b]
            # alu
            of ADD:  mem[a] = mem[a] + mem[b]
            of SUB:  mem[a] = mem[a] - mem[b]
            of MUL:  mem[a] = mem[a] * mem[b]
            of DIV:  mem[a] = mem[a] div mem[b]
            of MOD:  mem[a] = mem[a] mod mem[b]
            of NEG:  mem[a] = -mem[a] # b is ignored
            # cmp
            of EQ:   mem[a] = (mem[a] == mem[b]).ord.Word
            of NE:   mem[a] = (mem[a] != mem[b]).ord.Word
            of LT:   mem[a] = (mem[a] <  mem[b]).ord.Word
            of LE:   mem[a] = (mem[a] <= mem[b]).ord.Word
            of GT:   mem[a] = (mem[a] >  mem[b]).ord.Word
            of GE:   mem[a] = (mem[a] >= mem[b]).ord.Word
            # stdio - TODO: as extension
            of PUTI: echo mem[a]
            of PUTC: echo mem[a].char
            of GETC: mem[a] = sio.read_chr().Word
            of GETI: mem[a] = sio.read_int().Word
            of EOF:  mem[a] = sio.eof.ord.Word
            # misc
            of HLT:  pc=0
            # MK11
            of CMP: acc = mem[a] - mem[b]
            of JEQ:
                if acc == 0: pc=a
            of JGT:
                if acc > 0:  pc=a
            of JLT:
                if acc < 0:  pc=a
            of JNE:
                if acc != 0: pc=a
            of JGE:
                if acc >= 0: pc=a
            of JLE:
                if acc <= 0: pc=a
            else:
                quit("unknown opcode op:" & $op, 1)
        if pc==0: break

include cli
if is_main_module:
    cli()
