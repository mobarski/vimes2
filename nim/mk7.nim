# mk7: register-based vm inspired by Human Resource Machine

import strformat
import vimes/sio
import vimes/load
import bench

include mk7_opcodes
include mk7_opnames
type Word = int16

var pc: Word # program counter
var acc: Word # accumulator
var cc: int64 # used only when -d:cc is passed
var mem:   seq[Word] = @[] # memory
var code:  seq[Word] = @[] # program
var stack: seq[Word] = @[] # return stack (not used)

proc reset(quick=false) =
    pc=0; acc=0; cc=0
    if quick: return
    for j in low(mem)..high(mem):
        mem[j] = 0

proc trace(op,a:Word) =
    let opname = opnames[cast[Instr](op)]
    let va = mem[a]
    stderr.write_line """| {cc:3} | {pc:2} | {acc:3} | {opname:>4} {a:2} | {va:3} | """.fmt

proc debug() =
    echo "pc:", pc, " acc:", acc, " cc:", cc

proc run() =
    while true:
        # {.computedGoto.} # 10% slower :(
        let op = cast[Instr]( code[pc] )
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
            of OUT: echo acc # stdout.write $acc & " "
            of IN:  acc = sio.read_int().Word
            # misc
            of HLT: return
            else:
                quit("unknown opcode op:" & $op, 1)

include cli
if is_main_module:
    cli()
