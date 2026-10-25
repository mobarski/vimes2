// mk8 - accumulator machine (mk7 + pointers, subroutines, extra jumps)
// JavaScript port of nim/mk8.nim (superset of c/mk8c.c: also LPAO/SPAO)
//
// Browser: <script src="../js/vimes.js"></script> <script src="../js/opcodes.js"></script> <script src="../js/mk8.js"></script>
// Node:    node js/mk8.js prog.b10 [-b n] < input

(function (root) {
    'use strict'

    const V = (typeof require !== 'undefined' && typeof module !== 'undefined')
        ? (require('./opcodes.js'), require('./vimes.js'))
        : root.VIMES
    const OP = V.opcodes.mk8
    const i16 = V.i16

    const opnames = []
    for (const k in OP) opnames[OP[k]] = k

    // === SWITCH DISPATCH =====================================================

    function runSwitch(vm) {
        const code = vm.code, mem = vm.mem, stack = vm.stack, input = vm.input, out = vm.out
        const trace = vm.trace, maxCycles = vm.maxCycles
        let pc = 0, sp = 0, acc = 0, cc = 0
        let b = 0
        while (true) {
            const op = code[pc]
            const a = code[pc + 1]
            cc += 1
            if (trace) trace({ cc, pc, op, opname: opnames[op], a, acc, sp })
            if (maxCycles && cc > maxCycles) throw new Error(`mk8: cycle limit ${maxCycles} exceeded`)
            pc += 2
            switch (op) {
                // control flow
                case OP.JZ:   if (acc === 0) pc = a;          break
                case OP.JN:   if (acc < 0)   pc = a;          break
                case OP.JMP:  pc = a;                         break
                // data transfer
                case OP.LDA:  acc = mem[a];                   break
                case OP.LIT:  acc = a;                        break
                case OP.STA:  mem[a] = acc;                   break
                // alu
                case OP.ADD:  acc = i16(acc + mem[a]);        break
                case OP.SUB:  acc = i16(acc - mem[a]);        break
                case OP.INC:  mem[a] += 1;                    break
                case OP.DEC:  mem[a] -= 1;                    break
                // stdio
                case OP.OUT:  out.push(acc);                  break
                case OP.IN:   acc = i16(input.readInt());     break
                // other
                case OP.HLT:  vm.cc = cc; vm.regs = { pc, sp, acc }; return
                // MK8
                case OP.CAL:  stack[sp] = pc; sp += 1; pc = a; break
                case OP.RET:  sp -= 1; pc = stack[sp];        break
                case OP.LPA:  acc = mem[mem[a]];              break
                case OP.SPA:  mem[mem[a]] = acc;              break
                case OP.ASR:  acc = acc >> a;                 break
                case OP.NOP:                                  break
                // EXTENSION
                case OP.PUSH: mem[a] += 1; mem[mem[a]] = acc; break
                case OP.POP:  acc = mem[mem[a]]; mem[a] -= 1; break
                case OP.JP:   if (acc > 0)   pc = a;          break
                case OP.JZP:  if (acc >= 0)  pc = a;          break
                case OP.JZN:  if (acc <= 0)  pc = a;          break
                // EXTENSION 3 (3 words: op a b)
                case OP.LPAO: b = code[pc]; pc += 1; acc = mem[i16(mem[a] + b)]; break
                case OP.SPAO: b = code[pc]; pc += 1; mem[i16(mem[a] + b)] = acc; break
                default:
                    vm.cc = cc; vm.regs = { pc, sp, acc }
                    throw new Error(`mk8: unknown opcode ${op} at pc=${pc - 2}`)
            }
        }
    }

    const machine = V.register({
        name: 'mk8',
        description: 'accumulator machine (HRM-like): acc, mem, return stack; 2 words per instruction',
        opcodes: OP,
        opnames: opnames,
        variants: { switch: runSwitch },
    })

    if (typeof module !== 'undefined' && module.exports) {
        module.exports = machine
        if (require.main === module) V.cliMain(machine, process.argv.slice(2))
    }
})(typeof window !== 'undefined' ? window : globalThis)
