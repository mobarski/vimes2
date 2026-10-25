// mk12 - accumulator machine with mul/div/mod, compare ops, pointers and subroutines
// JavaScript port of nim/mk12.nim
//
// Node: node js/mk12.js prog.b10 [-b n] < input
(function (root) {
    'use strict'

    const V = (typeof require !== 'undefined' && typeof module !== 'undefined')
        ? (require('./opcodes.js'), require('./vimes.js'))
        : root.VIMES
    const i16 = V.i16
    const NAME = 'mk12'
    const OP = V.opcodes.mk12
    const opnames = V.opnamesOf(OP)

    function runSwitch(vm) {
        const code = vm.code, mem = vm.mem, stack = vm.stack, input = vm.input, out = vm.out
        const trace = vm.trace, maxCycles = vm.maxCycles
        const CODEN = code.length - 3, MEMN = mem.length, STN = stack.length
        let pc = 0, sp = 0, acc = 0, cc = 0, pc0 = 0
        const err = msg => { vm.cc = cc; V.fail(vm, NAME, msg, { pc: pc0, sp, acc }) }
        const ix = i => { if (i < 0 || i >= MEMN) err(`memory address ${i} out of range 0..${MEMN - 1}`); return i }
        const nz = x => { if (x === 0) err('division by zero'); return x }
        while (true) {
            if (pc < 0 || pc >= CODEN) { pc0 = pc; err(`pc out of code range`) }
            pc0 = pc
            const op = code[pc]
            const a = code[pc + 1]
            cc += 1
            if (trace) trace({ cc, pc, op, opname: opnames[op], a, acc, sp })
            if (maxCycles && cc > maxCycles) err(`cycle limit ${maxCycles} exceeded`)
            pc += 2
            switch (op) {
                // control flow
                case OP.JZ:   if (acc === 0) pc = a;      break
                case OP.JNZ:  if (acc !== 0) pc = a;      break
                case OP.CAL:
                    if (sp >= STN) err('return stack overflow')
                    stack[sp] = pc; sp += 1; pc = a;      break
                case OP.RET:
                    if (sp <= 0) err('return stack underflow')
                    sp -= 1; pc = stack[sp];              break
                case OP.JMP:  pc = a;                     break
                // memory
                case OP.LIT:  acc = a;                    break
                case OP.LDA:  acc = mem[a];               break
                case OP.STA:  mem[a] = acc;               break
                case OP.PEEK: acc = mem[ix(mem[a])];      break
                case OP.POKE: mem[ix(mem[a])] = acc;      break
                // alu
                case OP.ADD:  acc = i16(acc + mem[a]);    break
                case OP.SUB:  acc = i16(acc - mem[a]);    break
                case OP.MUL:  acc = i16(Math.imul(acc, mem[a])); break
                case OP.DIV:  acc = i16(Math.trunc(acc / nz(mem[a]))); break
                case OP.MOD:  acc = i16(acc % nz(mem[a])); break
                case OP.NEG:  acc = i16(-acc);            break
                // cmp
                case OP.EQ:   acc = +(acc === mem[a]);    break
                case OP.NE:   acc = +(acc !== mem[a]);    break
                case OP.LT:   acc = +(acc <   mem[a]);    break
                case OP.LE:   acc = +(acc <=  mem[a]);    break
                case OP.GT:   acc = +(acc >   mem[a]);    break
                case OP.GE:   acc = +(acc >=  mem[a]);    break
                // stdio
                case OP.PUT:  out.push(acc);              break
                case OP.GET:  acc = i16(input.readInt()); break
                case OP.EOF:  acc = +input.eof;           break
                case OP.GETC: acc = i16(input.readChr()); break
                case OP.PUTC: out.push(String.fromCharCode(acc & 0xFF)); break
                // misc
                case OP.HLT:  vm.cc = cc; vm.regs = { pc, sp, acc }; return
                case OP.INC:  mem[a] += 1;                break
                case OP.DEC:  mem[a] -= 1;                break
                default: err(`unknown opcode ${op}`)
            }
        }
    }

    const machine = V.register({
        name: NAME,
        description: 'accumulator machine: acc, mem, return stack, mul/div/mod and compare ops; 2 words per instruction',
        opcodes: OP, opnames,
        variants: { switch: runSwitch },
    })

    if (typeof module !== 'undefined' && module.exports) {
        module.exports = machine
        if (require.main === module) V.cliMain(machine, process.argv.slice(2))
    }
})(typeof window !== 'undefined' ? window : globalThis)
