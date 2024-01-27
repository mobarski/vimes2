# mk6: register-based vm inspired by Smol

import strformat
import vimes/sio
import vimes/load

include mk6_opcodes

type Cell = int16

var pc: Cell # program counter
var sp: Cell # stack pointer
var mem: seq[Cell] = @[] # memory
var st: seq[Cell] = @[] # stack
var cc: int64 # used only when -d:cc is passed
#var code: seq[Cell] = @[] # program

proc trace(a,b:Cell) =
    stderr.write_line """| {cc:2} | {pc:2} | {sp} | {mem[pc]} {a} {b} | mem[{a}] = {mem[a]} | mem[{b}] = {mem[b]}""".fmt

proc run(code: openArray[Cell]) =
    while true:
        let op = cast[Instr]( code[pc] )
        let a = code[pc+1]
        let b = code[pc+2]
        
        when defined(cc):    cc+=1
        when defined(trace): trace(a,b)

        pc += 3
        case op:
            # control flow
            of JZ:
                if mem[a]==0: pc=b
            of JNZ:
                if mem[a]!=0: pc=b
            of CAL:  st[sp]=pc; sp+=1; pc=a   # b is ignored
            of RET:  sp-=1; pc=st[sp]         # a and b are ignored
            of JMP:  pc=a                     # b is ignored
            # memory
            of LIT:  mem[a] = b
            of MOV:  mem[a] = mem[b]
            of PEEK: mem[a] = mem[mem[b]]
            of POKE: mem[mem[a]] = mem[b]
            # alu
            of ADD:  mem[a] = mem[a] + mem[b]
            of MUL:  mem[a] = mem[a] * mem[b]
            of DIV:  mem[a] = mem[a] div mem[b]
            of MOD:  mem[a] = mem[a] mod mem[b]
            of NEG:  mem[a] = -mem[a] # b is ignored
            # cmp
            of EQ:   mem[a] = (mem[a] == mem[b]).ord.Cell
            of NE:   mem[a] = (mem[a] != mem[b]).ord.Cell
            of LT:   mem[a] = (mem[a] <  mem[b]).ord.Cell
            of LE:   mem[a] = (mem[a] <= mem[b]).ord.Cell
            of GT:   mem[a] = (mem[a] >  mem[b]).ord.Cell
            of GE:   mem[a] = (mem[a] >= mem[b]).ord.Cell
            # stdio - TODO: as extension
            of PUTI: echo mem[a]
            of PUTC: echo mem[a].char
            of GETC: mem[a] = sio.read_chr().Cell
            of GETI: mem[a] = sio.read_int().Cell
            of EOF:  mem[a] = sio.eof.ord.Cell
            else:
                quit("unknown opcode op:" & $op, 1)

        if pc==0: break
