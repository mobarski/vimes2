// asm.js - JavaScript port of python/asm.py (simple, one-file, universal assembler for p-code)
// Must produce exactly the same output as asm.py (checked by tools/asm_parity.py).
//
// Browser: window.VIMES.asm.compile(text, opcodes)
// Node:    node js/asm.js <opcodes_path> <asm_path>   -> b10 on stdout

(function (root) {
    'use strict'

    const CFG = {
        line_comment: [';', '#', '--'],
        inline_comment_re: /\(.*?\)/g,
        kv_separator: '=',
        kv_token_separator: ',',
        kv_iters: 100,
        case_insensitive: true,
    }

    // compile text into p-code (see python/asm.py for the description)
    function compile(text, opcodes, withLabels = false) {
        if (CFG.case_insensitive) {
            text = text.toLowerCase()
            const lower = Object.create(null)
            for (const k in opcodes) lower[k.toLowerCase()] = opcodes[k]
            opcodes = lower
        }
        const lines = text.split('\n')
        // first pass - collect labels
        const label = Object.create(null)
        const kv = Object.create(null)
        let tokens = []
        let currentLabel = '_'
        for (let line of lines) {
            line = line.replace(CFG.inline_comment_re, '')
            const lineTokens = line.split(/\s+/)
            let breakOuter = false
            for (const token of lineTokens) {
                if (!token) continue
                // comments
                for (const lc of CFG.line_comment) {
                    if (token.startsWith(lc)) { breakOuter = true; break }
                }
                if (breakOuter) break
                // labels
                if (token[token.length - 1] === ':') {
                    let name = token.slice(0, -1)
                    if (name[0] === '.') name = currentLabel + name
                    else currentLabel = name
                    label[name] = tokens.length
                } else if (token[0] === '.') { // local label
                    tokens.push(currentLabel + token)
                // kv definitions
                } else if (token.includes(CFG.kv_separator)) {
                    const i = token.indexOf(CFG.kv_separator)
                    kv[token.slice(0, i)] = token.slice(i + 1).split(CFG.kv_token_separator)
                // kv use
                } else if (token in kv) {
                    let newTokens = kv[token]
                    let resolved = newTokens
                    for (let it = 0; it < CFG.kv_iters; it++) {
                        resolved = []
                        for (const t of newTokens) {
                            if (!t) continue // skip empty tokens
                            if (t in kv) resolved.push(...kv[t]); else resolved.push(t)
                        }
                        if (resolved.length === newTokens.length && resolved.every((t, j) => t === newTokens[j])) break
                        newTokens = resolved
                    }
                    tokens.push(...resolved)
                } else {
                    tokens.push(token)
                }
            }
        }
        // second pass - all labels are known
        const out = []
        for (const token of tokens) {
            if (token in label) out.push(label[token])
            else if (token in opcodes) out.push(opcodes[token])
            else if (/^[+-]?\d+(_\d+)*$/.test(token)) out.push(parseInt(token.replace(/_/g, ''), 10))
            else throw new Error(`Unknown token "${token}"`)
        }
        return withLabels ? [out, label] : out
    }

    // opcodes from text: lines like "ADD=5" (Nim enum) or "ADD = 5," (C enum)
    function getOpcodesFromText(text) {
        const opcodes = {}
        const re = /([A-Z][A-Z0-9_]*)\s*[:=]*\s*(\d+)/g
        for (const line of text.split('\n')) {
            const l = line.trim()
            if (!l) continue
            let m
            re.lastIndex = 0
            while ((m = re.exec(l)) !== null) opcodes[m[1]] = parseInt(m[2], 10)
        }
        return opcodes
    }

    const asm = { compile, getOpcodesFromText, CFG }

    if (typeof module !== 'undefined' && module.exports) module.exports = asm
    root.VIMES = root.VIMES || {}
    root.VIMES.asm = asm

    if (typeof require !== 'undefined' && typeof module !== 'undefined' && require.main === module) {
        const fs = require('fs')
        const [opcPath, asmPath] = process.argv.slice(2)
        if (!opcPath || !asmPath) {
            process.stderr.write('Usage: node js/asm.js <opcodes_path> <asm_path>\n')
            process.exit(1)
        }
        const opcodes = getOpcodesFromText(fs.readFileSync(opcPath, 'utf8'))
        const code = compile(fs.readFileSync(asmPath, 'utf8'), opcodes)
        process.stdout.write(code.join(' ') + '\n')
    }
})(typeof window !== 'undefined' ? window : globalThis)
