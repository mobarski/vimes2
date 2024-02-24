# Vimes2 - Virtual Machines Experimentation Sandbox 2

Another take on my [Vimes project](https://github.com/mobarski/vimes).

**Vimes** is a collection of virtual machines (VMs) and related resources for studying their performance, ease of  implementation, and ease of use. This sandbox includes a variety of VMs  with different architectures, dispatch techniques and implementations as well as benchmarks and utilities to help measure and  compare their characteristics.

**Warning**: this is experimental / pre-alpha code.



## Key Takeaways

**Development:**

- VM instruction sets are easy to implement, as each instruction is relatively simple.
- The biggest investments (so far) when creating a new VM are:

  - Transforming assembly into machine code.
  - Loading machine code into the VM.
  - Creating a buffered reader and an int parser for stdin.
  - Creating CLI.
  - Creating tests and benchmarks.
- The ability to define aliases for values (like `n=1`) and mnemonics (like `peek=lpa`) is a huge step forward in assembly UX with very little changes in the assembler (1 token is still 1 token).
- The ability to define multi-token aliases facilitates keeping the instruction set orthogonal (ie you can quickly add stacks with `peek`, `poke`, `inc`, `dec` and they can either grow up or down).
- Having all 3 conditional jumps related to comparison (<0, >0, ==0) makes the code much easier to write and read.
- Having array like access (ptr+offset) vs just pointers is a huge step forward in the assembly UX.

**Performance:**

- 🔥 [benchmarking results](benchmark.md) 🔥

- Wirth's machine is 2-3 times slower than register machines without stack frames.

- C enables more performant dispatch techniques, such as indirect and direct threading.

- Indirect and direct threading are twice as fast as switch-based dispatch.

- Indirect threading seems to be the best approach when writing a VM in C (10% slower but no code remapping).

- The performance of C programs compiled with Zig is similar to that of programs compiled with gcc (±20%).

- Nim's {.computedGoto.} pragma resulted in 10% slower code.

- Translation of machine code into C results in **extremely** fast execution but the return from the procedure call is a bit tricky.

- Zig acting as a C compiler outshines gcc in optimization of the translated machine code.

  

## VM versions

- **mk1** - machine from [Wirth](https://en.wikipedia.org/wiki/Niklaus_Wirth)'s 1976 book [Algorithms + Data Structures = Programs](https://en.wikipedia.org/wiki/Algorithms_%2B_Data_Structures_%3D_Programs)

  - **mk2** - `mk1` with variable number of arguments, swapped a and l
    - **mk3** - internal bytecode version of `mk2`
      - **abandoned** as bytecode requires more work than fixed-width words - instructions variants and assembler changes (🛑)

    - **mk4** - switch call threading version of `mk2`
    - **mk5** - indirect call threading version of `mk2`
- **mk6** - register based vm inspired by [smol](https://github.com/mobarski/smol)
  - **mk11** - similar to `mk6` but conditional jumps are based on `acc` register
    - **mk13** - similar to `mk11` but closer to the [smol](https://github.com/mobarski/smol) language
  - **mk12** - one operand version ok `mk6`
  - **mkXX**- `mk6` with stack frame similar to `mk1` (🌱)
- **mk7** - register based vm inspired by [Human Resource Machine](https://store.steampowered.com/app/375820/Human_Resource_Machine/)
  - **mk7c** - `mk7` implemented in C
  - **mk7ci** - `mk7` implementation in C, indirect threading
  - **mk7cd** - `mk7` implementation in C, direct threading
  - **mk7cc** - `mk7` asm compiled to C code (🚧)
  - **mk8** - `mk7` extended with pointer operations, subroutine call/return and one more conditional jump (🏆)
    - **mk8c** - `mk8` implemented in C
    - **mk8ci** - `mk8` implemented in C, indirect threading
    - **mk8cd** - `mk8` implemented in C, indirect threading
    - **mk8cc** - `mk8` asm compiled to C code (🚧)
  - **mkXX** - `mk7` extended with cooperative multitasking instructions (🌱)
- **mk9** - two operands version of `mk7`

  - **mk10** - `mk9` extended with pointer operations and subroutine call/return
    - **mkXX** - `mk10` with better UX (🌱)




## VM registers / variable names

### mk1 - mk5

These machines use the same variable names as Wirth's example p-code machine from 1976 (available [here](https://en.wikipedia.org/wiki/P-code_machine#Example_machine)).

- **p** - program register

- **b** - base register

- **t** - topstack register

- **s** - stack

- **i** - instruction register

- **a** - argument register

- **l** - level register

- **code** - program memory

  

## VM instructions

### mk1 - mk5

Basic instructions:

```
- LIT a   ; load constant (a)
- INT a   ; increment t-register by (a)
- LOD a b ; load variable (a) from level (b)
- STO a b ; store variable (a) at level (b)
- CAL a b ; call procedute (a) at level (b)
- JMP a   ; jump to (a)
- JPC a   ; jump conditional to (a)
- OPR a   ; execute operation (a) ie OPR ADD
- EX1 a   ; execute operation (a) from VM extension 1
- EX2 a   ; execute operation (a) from VM extension 2
- EX3 a   ; execute operation (a) from VM extension 3
  ...
- HLT     ; halt the program
```

**operations:**

```
- ADD ; (ab--c)  c = a + b
- SUB ; (ab--c)  c = a - b
- MUL ; (ab--c)  c = a * b
- DIV ; (ab--c)  c = 
- RET ; (ab--c)  c = 
- NEG ; (a--b)   b = -a
- ODD ; (a--b)   b = a % 2
- MOD ; (ab--c)  c = a % b
- EQ  ; (ab--c)  c = 1 if a==b else 0
- NE  ; (ab--c)  c = 1 if a!=b else 0
- LT  ; (ab--c)  c = 1 if a<b  else 0
- LE  ; (ab--c)  c = 1 if a<=b else 0
- GT  ; (ab--c)  c = 1 if a>b  else 0
- GE  ; (ab--c)  c = 1 if a>=b else 0
```

The notation `(ab--c)` describes the stack effect of an operation. It indicates that the  operation expects two items to be on the stack before execution,  referred to as `a` and `b`, and after the operation is executed, these items are replaced by a single item `c` on the stack. The items before `--` are consumed (popped) from the stack, and the items after `--` are produced (pushed) onto the stack.



Extension 1 - stdio:

- `PUTC`, `PUTI`
- `GETC`, `GETI`
- `EOF`

Extension 2 - ALU extension (bit ops):

- `AND`, `OR`, `XOR`, `NOT`
- `SHL`, `SHR`, `SAR`

Extension 3 - ALU extension (common ops)

- `INC`, `DEC`
- `EQZ`, `NEZ`, `LTZ`, `LEZ`, `GTZ`, `GEZ`



### mk6 instruction set

```
- LIT  a b  ; set memory location (a) to literal value (b)
- MOV  a b  ; set memory location (a) to value from memory location (b)
- PEEK a b  ; set memory location (a) with value from memory location indicated by (b)
- POKE a b  ; set memory location indicated by (a) to value from memory location (b)

- JMP  a 0  ; jump to program location (a)
- JZ   a b  ; if memory location (a) is zero then jump to program location (b)
- JNZ  a b  ; if memory location (a) is not zero then jump to program location (b)
- CAL  a 0  ; call subroutine at program location (a)
- RET  0 0  ; return from subroutine call
- HLT  0 0  ; halt the program

- ADD  a b  ; mem[a] = mem[a] + mem[b]
- SUB  a b  ; mem[a] = mem[a] - mem[b]
- MUL  a b  ; mem[a] = mem[a] * mem[b]
- DIV  a b  ; mem[a] = mem[a] / mem[b]
- MOD  a b  ; mem[a] = mem[a] % mem[b]
- NEG  a 0  ; mem[a] = -mem[a]

- EQ   a b  ; mem[a] = 1 if mem[a] == mem[b] else 0
- NE   a b  ; mem[a] = 1 if mem[a] != mem[b] else 0
- LT   a b  ; mem[a] = 1 if mem[a] <  mem[b] else 0
- LE   a b  ; mem[a] = 1 if mem[a] <= mem[b] else 0
- GT   a b  ; mem[a] = 1 if mem[a] >  mem[b] else 0
- GE   a b  ; mem[a] = 1 if mem[a] >= mem[b] else 0

- PUTC a 0  ; write the value from memory location (a) to stdout (as character)
- PUTI a 0  ; write the value from memory location (a) to stdout (as integer)
- GETC a 0  ; read a character from stdin and store it in memory location (a)
- GETI a 0  ; read an integer from stdin and store it in memory location (a), skip initial whitespaces
- EOF  a 0  ; set memory location (a) to 1 if stdin indicates end-of-file or to 0 otherwise

```

### mk7 instruction set

```
- IN  0  ; read input to ACC
- OUT 0  ; write ACC to output
- LDA a  ; load memory location (a) to ACC
- STA a  ; store ACC in memory location (a)
- ADD a  ; add memory location (a) to ACC
- SUB a  ; subtract memory location (a) from ACC
- INC a  ; increase memory location (a) by 1
- DEC a  ; decrease memory location (a) by 1
- JMP a  ; jump to address (a)
- JZ  a  ; jump to address (a) if ACC is zero
- JN  a  ; jump to address (a) if ACC is negative
- LIT a  ; load (a) to ACC
- HLT 0  ; halt the program
```



### mk8 instruction set

mk7 instructions extended with:

```
- CAL a ; call procedure at address (a)
- RET 0 ; return from procedure
- LPA a ; load memory location pointed by (a) to ACC
- SPA a ; store ACC in memory location pointed by (a)
```

misc instructions:

```
- ASR a ; arithmetic shift right ACC by (a)
- NOP a ; do nothing, (a) can be used to mark labels

```

### mk9 instruction set

```
- IN  a 0 ; read input to mem[a]
- OUT a 0 ; write mem[a] to output
- LIT a b ; mem[a] = b
- MOV a b ; mem[a] = mem[b]
- ADD a b ; mem[a] = mem[a] + mem[b]
- SUB a b ; mem[a] = mem[a] - mem[b]
- JMP a 0 ; jump to address (a)
- JZ  a b ; jump to address (a) if mem[b] is zero
- JN  a b ; jump to address (a) if mem[b] is negative
- HLT 0 0 ; halt the program
```

### mk10 instruction set

mk9 instructions extended with

```
- CAL a 0 ; call procedure at address (a)
- RET 0 0 ; return from procedure
- PTM a b ; transfer from pointer (b) to memory location (a)
- MTP a b ; transfer from memory location (b) to pointer (a)
- ASR a b ; arithmetic shift right mem[a] by (b)
- NOP a b ; do nothing, (a) can be used to mark labels
- JP  a b ; jump to address (a) if mem[b] is positve (>0)
```



### mk11 instruction set

```
- LIT  a b  ; mem[a] = b
- MOV  a b  ; mem[a] = mem[b]
- LDA  a 0  ; acc = mem[a] + b
- LDAP a b  ; acc = mem[mem[a]+mem[b]]
- STA  a 0  ; mem[a] = acc + b
- STAP a b  ; mem[mem[a]+mem[b]] = acc

- JMP  a 0  ; jump to program location (a)
- CAL  a 0  ; call subroutine at (a)
- RET  0 0  ; return from subroutine call
- HLT  0 0  ; halt the program

- ADD  a b  ; mem[a] = mem[a] + mem[b]
- SUB  a b  ; mem[a] = mem[a] - mem[b]
- MUL  a b  ; mem[a] = mem[a] * mem[b]
- DIV  a b  ; mem[a] = mem[a] / mem[b]
- MOD  a b  ; mem[a] = mem[a] % mem[b]
- NEG  a 0  ; mem[a] = -mem[a]

- CMP  a b  ; acc = mem[a] - mem[b] (compare)
- JEQ  a 0  ; jump to (a) if acc == 0
- JLT  a 0  ; jump to (a) if acc < 0
- JGT  a 0  ; jump to (a) if acc > 0
- JNE  a 0  ; jump to (a) if acc != 0
- JLE  a 0  ; jump to (a) if acc <= 0
- JGE  a 0  ; jump to (a) if acc >= 0

- GET  a 0  ; mem[a] = read integer from stdin (skip whitespace, block)
- PUT  a 0  ; write mem[a] as integer to stdout
- EOF  a 0  ; mem[a] = 1 if stdid.eof else 0
- GETC a 0  ; mem[a] = read character from stdin (block)
- PUTC a 0  ; write mem[a] as character to stdout
```

### mk12 instruction set

```
- LIT  a  ; acc = a
- LDA  a  ; acc = mem[a]
- STA  a  ; mem[a] = acc
- PEEK a  ; acc = mem[mem[a]]
- POKE a  ; mem[mem[a]] = acc

- JMP  a  ; jump to program location (a)
- CAL  a  ; call subroutine at (a)
- RET  0  ; return from subroutine call
- HLT  0  ; halt the program

- EQ   a  ; acc = 1 if acc == mem[b] else 0
- NE   a  ; acc = 1 if acc != mem[b] else 0
- LT   a  ; acc = 1 if acc <  mem[b] else 0
- LE   a  ; acc = 1 if acc <= mem[b] else 0
- GT   a  ; acc = 1 if acc >  mem[b] else 0
- GE   a  ; acc = 1 if acc >= mem[b] else 0
- JZ   a  ; jump to (a) if acc == 0 
- JNZ  a  ; jump to (a) if acc != 0

- ADD  a  ; acc += mem[a]
- SUB  a  ; acc -= mem[a]
- MUL  a  ; acc *= mem[a]
- DIV  a  ; acc /= mem[a]
- MOD  a  ; acc %= mem[a]
- NEG  0  ; acc = -acc
- INC  a  ; mem[a] += 1
- DEC  a  ; mem[b] -= 1

- PUT 0   ; write acc as integer to stdout
- GET 0   ; acc = read integer from stdin (skip whitespace, block)
- EOF  0  ; acc = 1 if stdid.eof else 0
- PUTC 0  ; write acc as character to stdout
- GETC 0  ; acc = read character from stdin (block)
```

### mk13 instruction set

```
- LIT  a b  ; mem[a] = b
- MOV  a b  ; mem[a] = mem[b]
- LDA  a b  ; acc = mem[a] + b
- LDAP a b  ; acc = mem[mem[a]+mem[b]]
- STA  a b  ; mem[a] = acc + b
- STAP a b  ; mem[mem[a]+mem[b]] = acc

- JMP  a 0  ; jump to program location (a)
- CAL  a 0  ; call subroutine at (a)
- RET  0 0  ; return from subroutine call
- HLT  0 0  ; halt the program

- ADD  a b  ; mem[a] = mem[a] + mem[b]
- SUB  a b  ; mem[a] = mem[a] - mem[b]
- MUL  a b  ; mem[a] = mem[a] * mem[b]
- DIV  a b  ; mem[a] = mem[a] / mem[b]
- MOD  a b  ; mem[a] = mem[a] % mem[b]
- NEG  a 0  ; mem[a] = -mem[a]

- EQ   a b  ; acc = 1 if mem[a] == mem[b] else 0
- NE   a b  ; acc = 1 if mem[a] != mem[b] else 0
- LT   a b  ; acc = 1 if mem[a] <  mem[b] else 0
- LE   a b  ; acc = 1 if mem[a] <= mem[b] else 0
- GT   a b  ; acc = 1 if mem[a] >  mem[b] else 0
- GE   a b  ; acc = 1 if mem[a] >= mem[b] else 0
- JZ   a 0  ; jump to (a) if acc == 0 
- JNZ  a 0  ; jump to (a) if acc != 0

- GET  a 0  ; mem[a] = read integer from stdin (skip whitespace, block)
- PUT  a 0  ; write mem[a] as integer to stdout
- EOF  a 0  ; mem[a] = 1 if stdid.eof else 0
- GETC a 0  ; mem[a] = read character from stdin (block)
- PUTC a 0  ; write mem[a] as character to stdout
```



# Trace example

### mk1 - mk5

```
+----+----+-----------+----+----+-------
| CC |  P |    I A    |  B |  T | S --> 
+----+----+-----------+----+----+-------
|  1 |  0 |  INT 2    |  0 |  0 | 
|  2 |  2 |  EX1 2    |  0 |  2 | 0 0
|  3 |  4 |  STO 1    |  0 |  3 | 0 0 1
|  4 |  7 |  CAL 17   |  0 |  2 | 1 0
|  5 | 17 |  INT 3    |  3 |  2 | 1 0
|  6 | 19 |  INT 1    |  3 |  5 | 1 0 0 0 10
|  7 | 21 |  LOD 1    |  3 |  6 | 1 0 0 0 10 0
|  8 | 24 |  STO 3    |  3 |  7 | 1 0 0 0 10 0 1
|  9 | 27 |  LOD 3    |  3 |  6 | 1 0 0 0 10 1
| 10 | 30 |  LIT 1    |  3 |  7 | 1 0 0 0 10 1 1
| 11 | 32 |  OPR 11   |  3 |  8 | 1 0 0 0 10 1 1 1
| 12 | 34 |  JPC 44   |  3 |  7 | 1 0 0 0 10 1 1
| 13 | 36 |  LOD 3    |  3 |  7 | 1 0 0 0 10 1 1
| 14 | 39 |  STO 2    |  3 |  8 | 1 0 0 0 10 1 1 1
| 15 | 42 |  OPR 0    |  3 |  7 | 1 1 0 0 10 1 1
| 16 | 10 |  LOD 2    |  0 |  2 | 1 1
| 17 | 13 |  EX1 1    |  0 |  3 | 1 1 1
| 18 | 15 |  JMP 0    |  0 |  2 | 1 1

```

## Reference materials

- https://github.com/mobarski/vimes/blob/main/references.md
- https://github.com/mobarski/vimes
- https://github.com/mobarski/smol
- PL/0 and p-code VM:
  - https://rosettacode.org/wiki/Category:PL/0
  - https://rosettacode.org/wiki/Category:XPL0
  - http://pascal.hansotten.com/niklaus-wirth/pl0/
  - https://en.wikipedia.org/wiki/P-code_machine

- Another World VM:
  - https://github.com/fabiensanglard/Another-World-Bytecode-Interpreter/blob/master/src/vm.cpp
  - https://fabiensanglard.net/anotherWorld_code_review/index.php
  - http://www.anotherworld.fr/anotherworld_uk/another_world.htm









