// mk11 - memory-to-memory machine with cmp + conditional jumps and acc for pointer access
// JavaScript port of nim/mk11.nim
//
// Node: node js/mk11.js prog.b10 [-b n] < input
(function (root) {
    'use strict'

    const V = (typeof require !== 'undefined' && typeof module !== 'undefined')
        ? (require('./opcodes.js'), require('./vimes.js'))
        : root.VIMES
    const i16 = V.i16
    const NAME = 'mk11'
    const OP = V.opcodes.mk11
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
            if (pc < 0 || pc >= CODEN) { pc0 = pc; err('pc out of code range') }
            pc0 = pc
            const op = code[pc]
            const a = code[pc + 1]
            const b = code[pc + 2]
            cc += 1
            if (trace) trace({ cc, pc, op, opname: opnames[op], a, b, va: mem[a], vb: mem[b], pc: pc0, sp, acc })
            if (maxCycles && cc > maxCycles) err(`cycle limit ${maxCycles} exceeded`)
            pc += 3
            switch (op) {
                // control flow
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
                // alu
                case OP.ADD:  mem[a] = mem[a] + mem[b]; break // Int16Array store wraps like int16
                case OP.SUB:  mem[a] = mem[a] - mem[b]; break
                case OP.MUL:  mem[a] = Math.imul(mem[a], mem[b]); break
                case OP.DIV:  mem[a] = Math.trunc(mem[a] / nz(mem[b])); break // Nim div truncates
                case OP.MOD:  mem[a] = mem[a] % nz(mem[b]); break               // Nim mod: sign of dividend
                case OP.NEG:  mem[a] = -mem[a];         break // b is ignored
                // stdio
                case OP.PUT:  out.push(mem[a]);         break // b is ignored
                case OP.GET:  mem[a] = input.readInt(); break // b is ignored
                case OP.EOF:  mem[a] = +input.eof;           break // b is ignored
                case OP.GETC: mem[a] = input.readChr();      break // b is ignored
                case OP.PUTC: out.push(String.fromCharCode(mem[a] & 0xFF)); break // b is ignored
                // misc
                case OP.HLT:  vm.cc = cc; vm.regs = { pc, sp, acc }; return
                // MK11 - cmp
                case OP.CMP:  acc = i16(mem[a] - mem[b]); break
                case OP.JEQ:  if (acc === 0) pc = a;    break // b is ignored
                case OP.JGT:  if (acc > 0)   pc = a;    break
                case OP.JLT:  if (acc < 0)   pc = a;    break
                case OP.JNE:  if (acc !== 0) pc = a;    break
                case OP.JGE:  if (acc >= 0)  pc = a;    break
                case OP.JLE:  if (acc <= 0)  pc = a;    break
                // MK11 - acc
                case OP.LDA:  acc = i16(mem[a] + b);    break
                case OP.LDAP: acc = mem[ix(i16(mem[a] + mem[b]))]; break
                case OP.STA:  mem[a] = acc + b;         break
                case OP.STAP: mem[ix(i16(mem[a] + mem[b]))] = acc; break
                default: err(`unknown opcode ${op}`)
            }
        }
    }

    const machine = V.register({
        name: NAME,
        description: 'memory-to-memory machine with CMP + conditional jumps, acc for pointer access; 3 words per instruction',
        opcodes: OP, opnames,
        variants: { switch: runSwitch },
    })

    if (typeof module !== 'undefined' && module.exports) {
        module.exports = machine
        if (require.main === module) V.cliMain(machine, process.argv.slice(2))
    }
})(typeof window !== 'undefined' ? window : globalThis)
