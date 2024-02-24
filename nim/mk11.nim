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
            of CAL:  stack[sp]=pc; sp+=1; pc=a # b is ignored
            of RET:  sp-=1; pc=stack[sp]       # a and b are ignored
            of JMP:  pc=a                      # b is ignored
            # memory
            of LIT:  mem[a] = b
            of MOV:  mem[a] = mem[b] # rename to set or copy ???
            # alu
            of ADD:  mem[a] = mem[a] + mem[b]
            of SUB:  mem[a] = mem[a] - mem[b]
            of MUL:  mem[a] = mem[a] * mem[b]
            of DIV:  mem[a] = mem[a] div mem[b]
            of MOD:  mem[a] = mem[a] mod mem[b]
            of NEG:  mem[a] = -mem[a] # b is ignored
            # stdio - TODO: change
            of PUT:  echo mem[a]                   # b is ignored
            of GET:  mem[a] = sio.read_int().Word  # b is ignored
            of EOF:  mem[a] = sio.eof.ord.Word     # b is ignored
            of GETC: mem[a] = sio.read_chr().Word  # b is ignored
            of PUTC: echo mem[a].char              # b is ignored  
            # misc
            of HLT:  break  # a and b ignored
            # MK11 - cmp
            of CMP: acc = mem[a] - mem[b]
            of JEQ:
                if acc == 0: pc=a  # b is ignored
            of JGT:
                if acc > 0:  pc=a  # b is ignored
            of JLT:
                if acc < 0:  pc=a  # b is ignored
            of JNE:
                if acc != 0: pc=a  # b is ignored
            of JGE:
                if acc >= 0: pc=a  # b is ignored
            of JLE:
                if acc <= 0: pc=a  # b is ignored
            # MK11 - acc
            of LDA:  acc = mem[a] + b 
            of LDAP: acc = mem[mem[a]+mem[b]]
            of STA:  mem[a] = acc + b
            of STAP: mem[mem[a]+mem[b]] = acc
            else:
                quit("unknown opcode op:" & $op, 1)

include cli
if is_main_module:
    cli()
