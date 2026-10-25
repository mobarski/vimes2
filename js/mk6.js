// mk6 - memory-to-memory machine inspired by Smol (3 words per instruction)
// JavaScript port of nim/mk6.nim
//
// Node: node js/mk6.js prog.b10 [-b n] < input
(function (root) {
    'use strict'

    const V = (typeof require !== 'undefined' && typeof module !== 'undefined')
        ? (require('./opcodes.js'), require('./vimes.js'))
        : root.VIMES
    const i16 = V.i16
    const NAME = 'mk6'
    const OP = V.opcodes.mk6
    const opnames = V.opnamesOf(OP)

    function runSwitch(vm) {
        const code = vm.code, mem = vm.mem, stack = vm.stack, input = vm.input, out = vm.out
        const trace = vm.trace, maxCycles = vm.maxCycles
        const CODEN = code.length - 3, MEMN = mem.length, STN = stack.length
        let pc = 0, sp = 0, acc = 0, cc = 0, pc0 = 0
        const err = msg => { vm.cc = cc; V.fail(vm, NAME, msg, { pc: pc0, sp }) }
        const ix = i => { if (i < 0 || i >= MEMN) err(`memory address ${i} out of range 0..${MEMN - 1}`); return i }
        const nz = x => { if (x === 0) err('division by zero'); return x }
        while (true) {
            if (pc < 0 || pc >= CODEN) { pc0 = pc; err('pc out of code range') }
            pc0 = pc
            const op = code[pc]
            const a = code[pc + 1]
            const b = code[pc + 2]
            cc += 1
            if (trace) trace({ cc, pc, op, opname: opnames[op], a, b, va: mem[a], vb: mem[b], pc: pc0, sp })
            if (maxCycles && cc > maxCycles) err(`cycle limit ${maxCycles} exceeded`)
            pc += 3
            switch (op) {
                // control flow
                case OP.JZ:   if (mem[a] === 0) pc = b; break
                case OP.JNZ:  if (mem[a] !== 0) pc = b; break
                case OP.CAL:
                    if (sp >= STN) err('return stack overflow')
                    stack[sp] = pc; sp += 1; pc = a; break // b is ignored
                case OP.RET:
                    if (sp <= 0) err('return stack underflow')
                    sp -= 1; pc = stack[sp];         break // a and b are ignored
                case OP.JMP:  pc = a;                   break // b is ignored
                // memory
                case OP.LIT:  mem[a] = b;               break
                case OP.MOV:  mem[a] = mem[b];          break
                case OP.PEEK: mem[a] = mem[ix(mem[b])]; break
                case OP.POKE: mem[ix(mem[a])] = mem[b]; break
                // alu
                case OP.ADD:  mem[a] = mem[a] + mem[b]; break // Int16Array store wraps like int16
                case OP.SUB:  mem[a] = mem[a] - mem[b]; break
                case OP.MUL:  mem[a] = Math.imul(mem[a], mem[b]); break
                case OP.DIV:  mem[a] = Math.trunc(mem[a] / nz(mem[b])); break // Nim div truncates
                case OP.MOD:  mem[a] = mem[a] % nz(mem[b]); break               // Nim mod: sign of dividend
                case OP.NEG:  mem[a] = -mem[a];         break // b is ignored
                // cmp
                case OP.EQ:   mem[a] = +(mem[a] === mem[b]); break
                case OP.NE:   mem[a] = +(mem[a] !== mem[b]); break
                case OP.LT:   mem[a] = +(mem[a] <   mem[b]); break
                case OP.LE:   mem[a] = +(mem[a] <=  mem[b]); break
                case OP.GT:   mem[a] = +(mem[a] >   mem[b]); break
                case OP.GE:   mem[a] = +(mem[a] >=  mem[b]); break
                // stdio
                case OP.PUTI: out.push(mem[a]);              break
                case OP.GETI: mem[a] = input.readInt();      break
                case OP.EOF:  mem[a] = +input.eof;           break // b is ignored
                case OP.GETC: mem[a] = input.readChr();      break // b is ignored
                case OP.PUTC: out.push(String.fromCharCode(mem[a] & 0xFF)); break // b is ignored
                // misc
                case OP.HLT:  pc = 0;                   break
                default: err(`unknown opcode ${op}`)
            }
            if (pc === 0) { vm.cc = cc; vm.regs = { pc, sp }; return } // HLT sets pc=0 (also: jump to 0 halts)
        }
    }

    const machine = V.register({
        name: NAME,
        description: 'memory-to-memory machine (Smol-like): mem, return stack; 3 words per instruction',
        opcodes: OP, opnames,
        variants: { switch: runSwitch },
    })

    if (typeof module !== 'undefined' && module.exports) {
        module.exports = machine
        if (require.main === module) V.cliMain(machine, process.argv.slice(2))
    }
})(typeof window !== 'undefined' ? window : globalThis)
