# vimes2 in the browser

Every vimes2 machine has a JavaScript version that runs in the browser and in Node.

## Usage

- Browser: open `web/index.html` from disk (file://). Plain `<script>` files only, so there is no server, bundler, or npm.
  - choose a machine and one of the test-case examples (source, input and expected output are filled in)
  - edit the assembly; it is assembled in the page by `js/asm.js` (a port of `python/asm.py`)
  - **Run** shows output, cycles, time, non-zero memory rows and the assembled code
  - **Trace** shows the first 200 executed instructions with registers
  - **Benchmark** runs the program N times and shows the average time and VM cycles/s
  - `web/index.html?selftest` runs every example on every variant and checks Run/Trace (used by `make test-web`)
- Node: `node js/mkN.js prog.b10 [-b n] [--variant v] [--debug] < input`

## Machines

| machine | family                      | words/instr | JS variants                  | reference          |
|---------|-----------------------------|-------------|------------------------------|--------------------|
| mk1     | p-code (original PL/0)      | 3 (i l a)   | switch                       | nim/mk1.nim        |
| mk2     | p-code, variable args       | 2-3         | switch, call (=mk4), table (=mk5) | nim/mk2.nim, mk4.nim, mk5.nim |
| mk6     | memory-to-memory (Smol)     | 3           | switch                       | nim/mk6.nim        |
| mk7     | accumulator (HRM)           | 2           | switch                       | nim/mk7.nim, c/mk7c.c |
| mk8     | accumulator + pointers      | 2 (3: LPAO/SPAO) | switch                  | nim/mk8.nim, c/mk8c.c |
| mk9     | memory-to-memory, minimal   | 3           | switch                       | nim/mk9.nim        |
| mk10    | memory-to-memory mk8        | 3           | switch                       | nim/mk10.nim       |
| mk11    | memory-to-memory + CMP      | 3           | switch                       | nim/mk11.nim       |
| mk12    | accumulator + mul/div/cmp   | 2           | switch                       | nim/mk12.nim       |
| mk13    | memory-to-memory + acc      | 3           | switch                       | nim/mk13.nim       |

mk3 (bytecode) is not ported - abandoned in the repo.

## Semantics notes

- Word is int16 everywhere: memory and stacks are `Int16Array` (stores wrap), registers use `(x << 16) >> 16`.
- `div` truncates toward zero and `mod` has the sign of the dividend (like Nim).
- stdin follows `nim/vimes/sio.nim`: line buffered, `GET`/`IN` at EOF returns -1 and sets the EOF flag,
  `GETC` returns 10 at the end of each line. (The C machines leave acc unchanged on EOF.)
  Unlike sio.nim, a non-numeric character in the input is skipped (sio.nim would loop forever).
- Output: numbers one per line, `PUTC` characters as-is (Nim `echo` adds a newline after a char; mk1/mk2 `PUTI` add no separator).
- mk6, mk9, mk1: `HLT` sets pc to 0 and any jump to 0 halts the machine (as in Nim).
- mk2: `HLT` halts and so does a jump to 0 on every variant (same as Nim mk2). Nim mk4/mk5 stop only on
  a jump to 0 (`HLT` is an unknown opcode in mk4 and crashes mk5 - fix on branch `necron/fix-nim-mk4-5-hlt`);
  JS accepts both, so every mk2 program runs on all JS variants.
- Runtime errors are reported as `mkN: <message> (pc=.. sp=.. acc=.. cc=..)`:
  pc outside the code, return stack overflow/underflow, indirect memory address out of range,
  division by zero, unknown opcode, cycle limit (the page uses 50M cycles). Direct addresses in
  instructions are not checked (a store to an address beyond memory is silently ignored).

## Verification

- `tools/run_tests.py`: every JS machine/variant against `tests/oracle.py`, plus equal cycle counts with the C and Nim
  variants (also for the p-code machines: Nim mk1, mk2, mk4, mk5).
- `tools/asm_parity.py`: `js/asm.js` == `python/asm.py` on every `asm/*.asm`.
