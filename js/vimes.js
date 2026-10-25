// vimes.js - shared runtime for vimes2 machines in JavaScript (browser + Node)
//
// Plain script (no ES modules) so web/index.html also works from file://.
// Browser: <script src="../js/vimes.js"></script> -> window.VIMES
// Node:    const V = require('./vimes.js')
//
// A machine module (js/mkN.js) calls VIMES.register({name, opcodes, opnames, words, run})
// where run(vm) executes vm.code until HLT and returns nothing; vm.cc = cycle counter.

(function (root) {
    'use strict'

    const V = root.VIMES || {}
    V.machines = V.machines || {}
    V.opcodes  = V.opcodes  || {}   // filled by js/opcodes.js (generated from nim/mkN_opcodes.nim)

    // === WORDS ==============================================================

    // 16-bit wrap-around (two's complement), same as int16_t in C and Nim -d:danger
    V.i16 = function (x) { return (x << 16) >> 16 }

    // === LOADER =============================================================

    // load machine code from text (space separated integers, .b10 format)
    V.codeFromNum = function (text, codeSize = 1000) {
        const nums = text.split(/\s+/).filter(t => t.length > 0)
        if (nums.length > codeSize) throw new Error('code too large for code array')
        const code = new Int16Array(codeSize + 4)
        for (let i = 0; i < nums.length; i++) {
            const n = parseInt(nums[i], 10)
            if (Number.isNaN(n)) throw new Error(`invalid number "${nums[i]}" at position ${i}`)
            code[i] = n
        }
        return code
    }

    // === STDIO ==============================================================

    // stdin model over an input string - same semantics as nim/vimes/sio.nim:
    // line buffered, read_int skips whitespace (EOF -> -1 and eof=true),
    // read_chr returns 10 at the end of every line (EOF -> -1 and eof=true).
    // Differences: a non-numeric char is skipped by readInt (sio.nim would loop forever).
    V.makeInput = function (text = '') {
        const lines = text.split('\n')
        if (lines.length > 1 && lines[lines.length - 1] === '') lines.pop() // like readLine: no extra empty line
        if (text === '') lines.length = 0
        let li = -1, buf = '', pos = 1
        const io = { eof: false }
        function nextLine() {
            li += 1
            if (li >= lines.length) { io.eof = true; return false }
            buf = lines[li].replace(/\r$/, ''); pos = 0
            return true
        }
        io.readInt = function () {
            while (true) {
                if (pos >= buf.length) {
                    if (!nextLine()) return -1
                }
                if (buf.length === 0) continue
                while (pos < buf.length && /\s/.test(buf[pos])) pos++
                if (pos >= buf.length) continue
                const m = /^[+-]?\d+/.exec(buf.slice(pos))
                if (m) { pos += m[0].length; return parseInt(m[0], 10) }
                pos += 1 // non-numeric char
            }
        }
        io.readChr = function () {
            while (true) {
                if (pos > buf.length) {
                    if (!nextLine()) return -1
                }
                if (pos === buf.length) { pos += 1; return 10 }
                return buf.charCodeAt(pos++)
            }
        }
        return io
    }

    // runtime error with machine state (clearer than NaN / undefined from typed arrays)
    V.VMError = class VMError extends Error {}
    V.fail = function (vm, machine, msg, regs) {
        vm.regs = regs || vm.regs
        const where = regs ? ' (' + Object.entries(regs).map(([k, v]) => `${k}=${v}`).join(' ') + ` cc=${vm.cc})` : ''
        throw new V.VMError(`${machine}: ${msg}${where}`)
    }

    // === VM =================================================================

    V.makeVM = function (code, opts = {}) {
        return {
            code: code,
            mem:   new Int16Array((opts.memSize   || 1000) + 4),
            stack: new Int16Array((opts.stackSize || 100)  + 4),
            input: V.makeInput(opts.input || ''),
            out: [],                  // output tokens (numbers, or chars for PUTC)
            cc: 0,                    // cycle counter (executed instructions)
            maxCycles: opts.maxCycles || 0, // 0 = unlimited
            trace: opts.trace || null,      // fn(info) called before each instruction
            regs: {},                 // final register values (for debug output)
        }
    }

    // opcode number -> name (for traces)
    V.opnamesOf = function (opcodes) {
        const names = []
        for (const k in opcodes) if (names[opcodes[k]] === undefined) names[opcodes[k]] = k
        return names
    }

    V.register = function (machine) {
        V.machines[machine.name] = machine
        return machine
    }

    // run a machine on b10 text with input text; returns {out, cycles, vm, ms}
    V.run = function (name, b10, inputText = '', opts = {}) {
        const m = V.machines[name]
        if (!m) throw new Error(`unknown machine ${name}`)
        const vm = V.makeVM(V.codeFromNum(b10, opts.codeSize), Object.assign({}, opts, { input: inputText }))
        const variant = opts.variant || 'switch'
        const run = m.variants[variant]
        if (!run) throw new Error(`${name}: unknown dispatch variant ${variant}`)
        const t0 = (typeof performance !== 'undefined') ? performance.now() : Date.now()
        run(vm)
        const t1 = (typeof performance !== 'undefined') ? performance.now() : Date.now()
        return { out: vm.out, cycles: vm.cc, vm: vm, ms: t1 - t0 }
    }

    // output tokens: numbers (PUT/OUT/PUTI) one per line, characters (PUTC) as-is
    V.outputText = function (out) {
        let s = ''
        for (const t of out) s += (typeof t === 'number') ? t + '\n' : t
        return s
    }

    // === MEMORY DUMP (like debug_mem in c/cli.h) ============================

    V.memDump = function (mem, N = 20) {
        const lines = []
        for (let j = 0; j + N <= mem.length; j += N) {
            let zeros = 0
            for (let k = 0; k < N; k++) if (mem[j + k] === 0) zeros++
            if (zeros === N) continue
            let line = String(j).padStart(4, '0') + ' '
            for (let k = 0; k < N; k++) {
                if (k % 5 === 0) line += '| '
                line += mem[j + k] + ' '
            }
            lines.push(line)
        }
        return lines.join('\n')
    }

    // === NODE CLI ===========================================================
    // node js/mkN.js prog.b10 [-b n] [--variant v] [--debug] < input
    //   stdout: program output (numbers separated by spaces)
    //   stderr: "cycles: N" (contract used by tools/run_tests.py)

    V.cliMain = function (machine, argv) {
        const fs = require('fs')
        let file = null, bench = 0, variant = 'switch', debug = false
        for (let i = 0; i < argv.length; i++) {
            if (argv[i] === '-b') bench = parseInt(argv[++i], 10)
            else if (argv[i] === '--variant') variant = argv[++i]
            else if (argv[i] === '--debug') debug = true
            else if (argv[i] === '--help') file = null, i = argv.length
            else file = argv[i]
        }
        if (!file) {
            process.stderr.write(`Usage: node js/${machine.name}.js <file.b10> [-b n] [--variant ${Object.keys(machine.variants).join('|')}] [--debug] < input\n`)
            process.exit(1)
        }
        const b10 = fs.readFileSync(file, 'utf8')
        let input = ''
        try { input = fs.readFileSync(0, 'utf8') } catch (e) { input = '' }
        const n = Math.max(bench, 1)
        let res, totalMs = 0, totalCycles = 0
        try {
            for (let i = 0; i < n; i++) {
                res = V.run(machine.name, b10, input, { variant })
                totalMs += res.ms; totalCycles += res.cycles
            }
        } catch (e) {
            if (!(e instanceof V.VMError)) throw e
            process.stderr.write(`ERROR: ${e.message}\n`)
            process.exit(2)
        }
        process.stdout.write(V.outputText(res.out))
        process.stderr.write(`cycles: ${res.cycles}\n`)
        if (bench > 0) {
            process.stderr.write(`runs: ${n}\navg time: ${(totalMs / n).toFixed(3)} ms\n`)
            process.stderr.write(`avg vm cycles/s: ${(totalCycles / (totalMs / 1000)).toExponential(2)}\n`)
        }
        if (debug) {
            process.stderr.write(V.memDump(res.vm.mem) + '\n')
            process.stderr.write(JSON.stringify(res.vm.regs) + '\n')
        }
    }

    V.isNodeMain = function (mod) {
        return typeof module !== 'undefined' && typeof require !== 'undefined' && require.main === mod
    }

    if (typeof module !== 'undefined' && module.exports) module.exports = V
    root.VIMES = V
})(typeof window !== 'undefined' ? window : globalThis)
