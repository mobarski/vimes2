# mk6: register-based vm inspired by Smol

import strformat
import vimes/sio
import vimes/load
import bench

include mk9_opcodes
include mk9_opnames
type Word = int16

var pc: Word # program counter
var cc: int64 # used only when -d:cc is passed
var mem:   seq[Word] = @[] # memory
var code:  seq[Word] = @[] # program
var stack: seq[Word] = @[] # return stack (not used)

proc reset(quick=false) =
    pc=0; cc=0
    if quick: return
    for j in low(mem)..high(mem):
        mem[j] = 0

proc trace(op,a,b:Word) =
    let opname = opnames[cast[Instr](op)]
    let va = mem[a]
    let vb = mem[b]
    stderr.write_line """| {cc:3} | {pc:2} | {opname:>4} {a:2} {b:2} | {va:3} | {vb:3} | """.fmt

proc debug() =
    echo "pc: {pc}  cc: {cc}".fmt

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
                if mem[b]==0: pc=a
            of JN:
                if mem[b]<0:  pc=a
            of JMP:           pc=a # b is ignored
            # memory
            of LIT:  mem[a] = b # rename to LOAD?
            of MOV:  mem[a] = mem[b]
            # alu
            of ADD:  mem[a] = mem[a] + mem[b]
            of SUB:  mem[a] = mem[a] - mem[b]
            # stdio
            of OUT: echo mem[a]
            of IN:   mem[a] = sio.read_int().Word
            # misc
            of HLT:  pc=0
            else:
                quit("unknown opcode op:" & $op, 1)
        if pc==0: break

include cli
if is_main_module:
    cli()
