// mk1 - Wirth's p-code machine, compatible with the original PL/0 (3 words: i l a)
// JavaScript port of nim/mk1.nim (+ nim/base.nim, nim/ex1.nim)
//
// Node: node js/mk1.js prog.b10 [-b n] < input

(function (root) {
    'use strict'

    const V = (typeof require !== 'undefined' && typeof module !== 'undefined')
        ? (require('./opcodes.js'), require('./vimes.js'))
        : root.VIMES
    const i16 = V.i16
    const NAME = 'mk1'
    const OP = V.opcodes.mk1   // main opcodes, OPR sub-opcodes and EX1 sub-opcodes share one table
    const STACK_SIZE = 1000
    const opnames = []
    for (const k of ['HLT', 'LIT', 'OPR', 'LOD', 'STO', 'CAL', 'INT', 'JMP', 'JPC', 'EX1']) opnames[OP[k]] = k
    const { LIT, OPR, LOD, STO, CAL, INT, JMP, JPC, EX1 } = OP
    const { RET, NEG, ADD, SUB, MUL, DIV, ODD, MOD, EQ, NE, LT, LE, GT, GE } = OP
    const { PUTI, GETI, PUTC, GETC, EOF } = OP

    function runSwitch(vm) {
        const code = vm.code, input = vm.input, out = vm.out
        const trace = vm.trace, maxCycles = vm.maxCycles
        const s = vm.mem = new Int16Array(STACK_SIZE) // stack (memory dump shows it)
        const CODEN = code.length - 3, SN = STACK_SIZE
        let p = 0, b = 0, t = 0, cc = 0, p0 = 0
        const err = msg => { vm.cc = cc; V.fail(vm, NAME, msg, { p: p0, b, t }) }
        const ix = i => { if (i < 0 || i >= SN) err(`stack address ${i} out of range 0..${SN - 1}`); return i }
        const nz = x => { if (x === 0) err('division by zero'); return x }
        const base = l => { let b1 = b; while (l > 0) { b1 = s[ix(b1)]; l -= 1 } return b1 }
        while (true) {
            if (p < 0 || p >= CODEN) { p0 = p; err('p out of code range') }
            p0 = p
            const i = code[p + 0]
            const l = code[p + 1]
            const a = code[p + 2]
            cc += 1
            if (trace) trace({ cc, pc: p, op: i, opname: opnames[i], l, a, b, t, top: s[t] })
            if (maxCycles && cc > maxCycles) err(`cycle limit ${maxCycles} exceeded`)
            p += 3
            switch (i) {
                case LIT: t += 1; s[t] = a;                     break
                case LOD: t += 1; s[t] = s[ix(base(l) + a)];   break
                case STO: s[ix(base(l) + a)] = s[t]; t -= 1;   break
                case INT: t += a;                              break
                case JMP: p = a;                               break
                case JPC: if (s[t] === 0) { p = a; t -= 1 }    break
                case CAL:
                    s[ix(t + 1)] = base(l)
                    s[ix(t + 2)] = b
                    s[ix(t + 3)] = p
                    b = t + 1
                    p = a
                    break
                case OPR:
                    switch (a) {
                        case RET: t = b - 1; p = s[ix(t + 3)]; b = s[t + 2]; break
                        case NEG: s[t] = -s[t];                         break
                        case ADD: t -= 1; s[t] = s[t] + s[t + 1];       break
                        case SUB: t -= 1; s[t] = s[t] - s[t + 1];       break
                        case MUL: t -= 1; s[t] = Math.imul(s[t], s[t + 1]); break
                        case DIV: t -= 1; s[t] = Math.trunc(s[t] / nz(s[t + 1])); break
                        case ODD: s[t] = s[t] % 2;                      break
                        case MOD: t -= 1; s[t] = s[t] % nz(s[t + 1]);   break
                        case EQ:  t -= 1; s[t] = +(s[t] === s[t + 1]);  break
                        case NE:  t -= 1; s[t] = +(s[t] !== s[t + 1]);  break
                        case LT:  t -= 1; s[t] = +(s[t] <   s[t + 1]);  break
                        case LE:  t -= 1; s[t] = +(s[t] <=  s[t + 1]);  break
                        case GT:  t -= 1; s[t] = +(s[t] >   s[t + 1]);  break
                        case GE:  t -= 1; s[t] = +(s[t] >=  s[t + 1]);  break
                        default: err(`unknown OPR opcode ${a}`)
                    }
                    break
                case EX1:
                    switch (a) {
                        case PUTI: out.push(s[t]); t -= 1;                              break
                        case PUTC: out.push(String.fromCharCode(s[t] & 0xFF)); t -= 1;  break
                        case GETI: t += 1; s[ix(t)] = input.readInt();                  break
                        case GETC: t += 1; s[ix(t)] = input.readChr();                  break
                        case EOF:  t += 1; s[ix(t)] = +input.eof;                       break
                        default: err(`unknown EX1 opcode ${a}`)
                    }
                    break
                default: err(`unknown opcode ${i}`)
            }
            if (t < -1 || t >= SN - 3) err(`stack pointer t=${t} out of range`)
            if (p === 0) { vm.cc = cc; vm.regs = { p, b, t }; return } // JMP 0 halts (no HLT in mk1)
        }
    }

    const machine = V.register({
        name: NAME,
        description: "Wirth's p-code machine (original PL/0): stack, static links; 3 words per instruction (i l a)",
        opcodes: OP, opnames,
        variants: { switch: runSwitch },
    })

    if (typeof module !== 'undefined' && module.exports) {
        module.exports = machine
        if (require.main === module) V.cliMain(machine, process.argv.slice(2))
    }
})(typeof window !== 'undefined' ? window : globalThis)
