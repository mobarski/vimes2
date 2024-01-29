# mk6: register-based vm inspired by Smol

import strformat
import vimes/sio
import vimes/load
import bench

include mk7_opcodes
include mk7_opnames
type Cell = int16

var pc: Cell # program counter
var acc: Cell # accumulator
var cc: int64 # used only when -d:cc is passed
var mem:   seq[Cell] = @[] # memory
var code:  seq[Cell] = @[] # program

proc reset(quick=false) =
    pc=0; acc=0; cc=0
    if quick: return
    for j in low(mem)..high(mem):
        mem[j] = 0

proc trace(op,a:Cell) =
    let opname = opnames[cast[Instr](op)]
    let va = mem[a]
    stderr.write_line """| {cc:3} | {pc:2} | {opname:>4} {a:2} | {va:3} | """.fmt

proc debug() =
    echo "pc:", pc, " acc:", acc, " cc:", cc

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
            of JN:
                if acc<0:  pc=a
            of JMP: pc=a
            # data transfer
            of LDA:  acc = mem[a]
            of LIT:  acc = a # EXTENSION
            of STA:  mem[a] = acc
            # alu
            of ADD:  acc += mem[a]
            of SUB:  acc -= mem[a]
            of INC:  mem[a] += 1
            of DEC:  mem[a] -= 1
            # stdio - TODO: as extension
            of OUT: echo acc; echo " "
            of IN:  acc = sio.read_int().Cell
            else:
                quit("unknown opcode op:" & $op, 1)
        if pc>=code.len: break

include cli
if is_main_module:
    mem   = new_seq[Cell](100) # TODO: option
    cli()
