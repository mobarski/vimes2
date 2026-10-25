// mk7 - accumulator machine inspired by Human Resource Machine
// JavaScript port of nim/mk7.nim (same semantics as c/mk7c.c)
//
// Node: node js/mk7.js prog.b10 [-b n] < input
(function (root) {
    'use strict'

    const V = (typeof require !== 'undefined' && typeof module !== 'undefined')
        ? (require('./opcodes.js'), require('./vimes.js'))
        : root.VIMES
    const i16 = V.i16
    const NAME = 'mk7'
    const OP = V.opcodes.mk7
    const opnames = V.opnamesOf(OP)

    function runSwitch(vm) {
        const code = vm.code, mem = vm.mem, input = vm.input, out = vm.out
        const trace = vm.trace, maxCycles = vm.maxCycles, CODEN = code.length - 3
        let pc = 0, acc = 0, cc = 0, pc0 = 0
        const err = msg => { vm.cc = cc; V.fail(vm, NAME, msg, { pc: pc0, acc }) }
        while (true) {
            if (pc < 0 || pc >= CODEN) { pc0 = pc; err(`pc out of code range`) }
            pc0 = pc
            const op = code[pc]
            const a = code[pc + 1]
            cc += 1
            if (trace) trace({ cc, pc, op, opname: opnames[op], a, acc })
            if (maxCycles && cc > maxCycles) err(`cycle limit ${maxCycles} exceeded`)
            pc += 2
            switch (op) {
                // control flow
                case OP.JZ:   if (acc === 0) pc = a;      break
                case OP.JN:   if (acc < 0)   pc = a;      break
                case OP.JMP:  pc = a;                     break
                // data transfer
                case OP.LDA:  acc = mem[a];               break
                case OP.LIT:  acc = a;                    break // EXTENSION
                case OP.STA:  mem[a] = acc;               break
                // alu
                case OP.ADD:  acc = i16(acc + mem[a]);    break
                case OP.SUB:  acc = i16(acc - mem[a]);    break
                case OP.INC:  mem[a] += 1;                break
                case OP.DEC:  mem[a] -= 1;                break
                // stdio
                case OP.OUT:  out.push(acc);              break
                case OP.IN:   acc = i16(input.readInt()); break
                // misc
                case OP.HLT:  vm.cc = cc; vm.regs = { pc, acc }; return
                default: err(`unknown opcode ${op}`)
            }
        }
    }

    const machine = V.register({
        name: NAME,
        description: 'accumulator machine (Human Resource Machine): acc, mem; 2 words per instruction',
        opcodes: OP, opnames,
        variants: { switch: runSwitch },
    })

    if (typeof module !== 'undefined' && module.exports) {
        module.exports = machine
        if (require.main === module) V.cliMain(machine, process.argv.slice(2))
    }
})(typeof window !== 'undefined' ? window : globalThis)
