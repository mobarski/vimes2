// mk2 - p-code machine with variable number of arguments (a and l swapped: "LOD a l")
// JavaScript port of nim/mk2.nim; dispatch variants:
//   switch - nim/mk2.nim (switch dispatch)
//   call   - nim/mk4.nim (call threading: one function per opcode, called from a switch)
//   table  - nim/mk5.nim (indirect call threading: function table indexed by opcode)
// All variants have the same semantics: HLT stops, and so does a jump to 0 (as in mk4/mk5),
// so programs written for mk2 (HLT) and for mk4/mk5 (JMP 0) both run on every variant.
//
// Node: node js/mk2.js prog.b10 [-b n] [--variant switch|call|table] < input

(function (root) {
    'use strict'

    const V = (typeof require !== 'undefined' && typeof module !== 'undefined')
        ? (require('./opcodes.js'), require('./vimes.js'))
        : root.VIMES
    const NAME = 'mk2'
    const OP = V.opcodes.mk1   // mk2 uses the mk1 opcode table (nim/mk1_opcodes.nim)
    const STACK_SIZE = 1000
    const opnames = []
    for (const k of ['HLT', 'LIT', 'OPR', 'LOD', 'STO', 'CAL', 'INT', 'JMP', 'JPC', 'EX1']) opnames[OP[k]] = k
    const { HLT, LIT, OPR, LOD, STO, CAL, INT, JMP, JPC, EX1 } = OP
    const { RET, NEG, ADD, SUB, MUL, DIV, ODD, MOD, EQ, NE, LT, LE, GT, GE } = OP
    const { PUTI, GETI, PUTC, GETC, EOF } = OP

    // === SWITCH DISPATCH (mk2) ===============================================

    function runSwitch(vm) {
        const code = vm.code, input = vm.input, out = vm.out
        const trace = vm.trace, maxCycles = vm.maxCycles
        const s = vm.mem = new Int16Array(STACK_SIZE)
        const CODEN = code.length - 3, SN = STACK_SIZE
        let p = 0, b = 0, t = 0, cc = 0, p0 = 0, l = 0
        const err = msg => { vm.cc = cc; V.fail(vm, NAME, msg, { p: p0, b, t }) }
        const ix = i => { if (i < 0 || i >= SN) err(`stack address ${i} out of range 0..${SN - 1}`); return i }
        const nz = x => { if (x === 0) err('division by zero'); return x }
        const base = l => { let b1 = b; while (l > 0) { b1 = s[ix(b1)]; l -= 1 } return b1 }
        while (true) {
            if (p < 0 || p >= CODEN) { p0 = p; err('p out of code range') }
            p0 = p
            const i = code[p + 0]
            const a = code[p + 1]
            cc += 1
            if (trace) trace({ cc, pc: p, op: i, opname: opnames[i], a, b, t, top: s[t] })
            if (maxCycles && cc > maxCycles) err(`cycle limit ${maxCycles} exceeded`)
            p += 2
            switch (i) {
                case LIT: t += 1; s[t] = a;                     break
                case INT: t += a;                              break
                case JMP: p = a;                               break
                case JPC: if (s[t] === 0) { p = a; t -= 1 }    break
                case LOD:
                    l = code[p]; p += 1
                    t += 1; s[t] = s[ix(base(l) + a)];         break
                case STO:
                    l = code[p]; p += 1
                    s[ix(base(l) + a)] = s[t]; t -= 1;         break
                case CAL:
                    l = code[p]; p += 1
                    s[ix(t + 1)] = base(l)
                    s[ix(t + 2)] = b
                    s[ix(t + 3)] = p
                    b = t + 1
                    p = a
                    break
                case OPR:
                    switch (a) {
                        case RET: t = b - 1; p = s[ix(t + 3)]; b = s[t + 2]; break
                        case ADD: t -= 1; s[t] = s[t] + s[t + 1];       break
                        case SUB: t -= 1; s[t] = s[t] - s[t + 1];       break
                        case MUL: t -= 1; s[t] = Math.imul(s[t], s[t + 1]); break
                        case DIV: t -= 1; s[t] = Math.trunc(s[t] / nz(s[t + 1])); break
                        case MOD: t -= 1; s[t] = s[t] % nz(s[t + 1]);   break
                        case ODD: s[t] = s[t] % 2;                      break
                        case NEG: s[t] = -s[t];                         break
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
                case HLT: vm.cc = cc; vm.regs = { p, b, t }; return
                default: err(`unknown opcode ${i}`)
            }
            if (t < -1 || t >= SN - 3) err(`stack pointer t=${t} out of range`)
            if (p === 0) { vm.cc = cc; vm.regs = { p, b, t }; return }
        }
    }

    // === CALL THREADING (mk4) and INDIRECT CALL THREADING (mk5) ==============

    function runThreaded(vm, useTable) {
        const code = vm.code, input = vm.input, out = vm.out
        const trace = vm.trace, maxCycles = vm.maxCycles
        const s = vm.mem = new Int16Array(STACK_SIZE)
        const CODEN = code.length - 3, SN = STACK_SIZE
        let p = 0, b = 0, t = 0, cc = 0, p0 = 0, halted = false
        const err = msg => { vm.cc = cc; V.fail(vm, NAME, msg, { p: p0, b, t }) }
        const ix = i => { if (i < 0 || i >= SN) err(`stack address ${i} out of range 0..${SN - 1}`); return i }
        const nz = x => { if (x === 0) err('division by zero'); return x }
        const base = l => { let b1 = b; while (l > 0) { b1 = s[ix(b1)]; l -= 1 } return b1 }

        function do_lod(a) { const l = code[p]; p += 1; t += 1; s[t] = s[ix(base(l) + a)] }
        function do_sto(a) { const l = code[p]; p += 1; s[ix(base(l) + a)] = s[t]; t -= 1 }
        function do_cal(a) {
            const l = code[p]; p += 1
            s[ix(t + 1)] = base(l)
            s[ix(t + 2)] = b
            s[ix(t + 3)] = p
            b = t + 1
            p = a
        }
        function do_lit(a) { t += 1; s[t] = a }
        function do_int(a) { t += a }
        function do_jmp(a) { p = a }
        function do_jpc(a) { if (s[t] === 0) { p = a; t -= 1 } }
        function do_hlt(a) { halted = true }
        function do_opr(a) {
            switch (a) {
                case RET: t = b - 1; p = s[ix(t + 3)]; b = s[t + 2]; break
                case ADD: t -= 1; s[t] = s[t] + s[t + 1];       break
                case SUB: t -= 1; s[t] = s[t] - s[t + 1];       break
                case MUL: t -= 1; s[t] = Math.imul(s[t], s[t + 1]); break
                case DIV: t -= 1; s[t] = Math.trunc(s[t] / nz(s[t + 1])); break
                case MOD: t -= 1; s[t] = s[t] % nz(s[t + 1]);   break
                case ODD: s[t] = s[t] % 2;                      break
                case NEG: s[t] = -s[t];                         break
                case EQ:  t -= 1; s[t] = +(s[t] === s[t + 1]);  break
                case NE:  t -= 1; s[t] = +(s[t] !== s[t + 1]);  break
                case LT:  t -= 1; s[t] = +(s[t] <   s[t + 1]);  break
                case LE:  t -= 1; s[t] = +(s[t] <=  s[t + 1]);  break
                case GT:  t -= 1; s[t] = +(s[t] >   s[t + 1]);  break
                case GE:  t -= 1; s[t] = +(s[t] >=  s[t + 1]);  break
                default: err(`unknown OPR opcode ${a}`)
            }
        }
        function do_ex1(a) {
            switch (a) {
                case PUTI: out.push(s[t]); t -= 1;                              break
                case PUTC: out.push(String.fromCharCode(s[t] & 0xFF)); t -= 1;  break
                case GETI: t += 1; s[ix(t)] = input.readInt();                  break
                case GETC: t += 1; s[ix(t)] = input.readChr();                  break
                case EOF:  t += 1; s[ix(t)] = +input.eof;                       break
                default: err(`unknown EX1 opcode ${a}`)
            }
        }
        function do_bad(a) { err(`unknown opcode ${code[p0]}`) }

        // mk5: function table indexed by opcode (unused slots -> do_bad)
        const table = []
        table[HLT] = do_hlt; table[LIT] = do_lit; table[OPR] = do_opr; table[LOD] = do_lod
        table[STO] = do_sto; table[CAL] = do_cal; table[INT] = do_int; table[JMP] = do_jmp
        table[JPC] = do_jpc; table[EX1] = do_ex1
        for (let k = 0; k < 256; k++) if (!table[k]) table[k] = do_bad

        while (true) {
            if (p < 0 || p >= CODEN) { p0 = p; err('p out of code range') }
            p0 = p
            const i = code[p + 0]
            const a = code[p + 1]
            cc += 1
            if (trace) trace({ cc, pc: p, op: i, opname: opnames[i], a, b, t, top: s[t] })
            if (maxCycles && cc > maxCycles) err(`cycle limit ${maxCycles} exceeded`)
            p += 2
            if (useTable) {
                const f = (i >= 0 && i < 256) ? table[i] : do_bad
                f(a)
            } else {
                switch (i) {
                    case LIT: do_lit(a); break
                    case LOD: do_lod(a); break
                    case STO: do_sto(a); break
                    case INT: do_int(a); break
                    case JMP: do_jmp(a); break
                    case JPC: do_jpc(a); break
                    case CAL: do_cal(a); break
                    case OPR: do_opr(a); break
                    case EX1: do_ex1(a); break
                    case HLT: do_hlt(a); break
                    default: do_bad(a)
                }
            }
            if (t < -1 || t >= SN - 3) err(`stack pointer t=${t} out of range`)
            if (halted || p === 0) { vm.cc = cc; vm.regs = { p, b, t }; return }
        }
    }

    const machine = V.register({
        name: NAME,
        description: 'p-code machine with variable number of arguments (LOD a l); variants: switch (mk2), call (mk4), table (mk5)',
        opcodes: OP, opnames,
        variants: {
            switch: runSwitch,
            call:  vm => runThreaded(vm, false),
            table: vm => runThreaded(vm, true),
        },
    })

    if (typeof module !== 'undefined' && module.exports) {
        module.exports = machine
        if (require.main === module) V.cliMain(machine, process.argv.slice(2))
    }
})(typeof window !== 'undefined' ? window : globalThis)
