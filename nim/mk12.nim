# mk6: register-based vm inspired by Smol

import strformat
import vimes/sio
import vimes/load
import bench

include mk12_opcodes
include mk12_opnames
type Word = int16

var pc: Word # program counter
var sp: Word # stack pointer
var acc: Word # accumulator
var cc: int64 # used only when -d:cc is passed
var mem:   seq[Word] = @[] # memory
var stack: seq[Word] = @[] # return stack
var code:  seq[Word] = @[] # program

proc reset(quick=false) =
    pc=0; sp=0; cc=0; acc=0;
    if quick: return
    for j in low(mem)..high(mem):
        mem[j] = 0
    for j in low(stack)..high(stack):
        stack[j] = 0

proc trace(op,a:Word) =
    let opname = opnames[cast[Instr](op)]
    let va = mem[a]
    stderr.write_line """| {cc:3} | {pc:2} | {acc:2} | {opname:>4} {a:2} | {va:3} | """.fmt

proc debug() =
    echo "pc:", pc, " sp:", sp, " cc:", cc

proc run() =
    while true:
        let opc = code[pc]
        let op = cast[Instr]( opc )
        let a = code[pc+1]
        
        when defined(cc):    cc+=1
        when defined(trace): trace(opc,a)

        pc += 2
        case op:
            # control flow
            of JZ:
                if acc==0: pc=a
            of JNZ:
                if acc!=0: pc=a
            of CAL:  stack[sp]=pc; sp+=1; pc=a
            of RET:  sp-=1; pc=stack[sp]
            of JMP:  pc=a
            # memory
            of LIT:  acc = a
            of LDA:  acc = mem[a]
            of STA:  mem[a] = acc
            of PEEK: acc = mem[mem[a]]
            of POKE: mem[mem[a]] = acc
            # alu
            of ADD:  acc += mem[a]
            of SUB:  acc -= mem[a]
            of MUL:  acc *= mem[a]
            of DIV:  acc = acc div mem[a]
            of MOD:  acc = acc mod mem[a]
            of NEG:  acc = -acc
            # cmp
            of EQ:   acc = (acc == mem[a]).ord.Word
            of NE:   acc = (acc != mem[a]).ord.Word
            of LT:   acc = (acc <  mem[a]).ord.Word
            of LE:   acc = (acc <= mem[a]).ord.Word
            of GT:   acc = (acc >  mem[a]).ord.Word
            of GE:   acc = (acc >= mem[a]).ord.Word
            # stdio - TODO: as extension
            of PUT:  echo acc
            of GET : acc = sio.read_int().Word
            of EOF:  acc = sio.eof.ord.Word
            of GETC: acc = sio.read_chr().Word
            of PUTC: echo acc.char
            # misc
            of HLT: break
            of INC: mem[a] += 1
            of DEC: mem[a] -= 1
            else:
                quit("unknown opcode op:" & $op, 1)

include cli
if is_main_module:
    cli()
