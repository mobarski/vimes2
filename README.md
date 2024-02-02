# Vimes2 - Virtual Machines Experimentation Sandbox 2

Another take on my [Vimes project](https://github.com/mobarski/vimes).

**Vimes** is a collection of virtual machines (VMs) and related resources for studying their performance, ease of  implementation, and ease of use. This sandbox includes a variety of VMs  with different architectures, dispatch techniques and implementations as well as benchmarks and utilities to help measure and  compare their characteristics.

**Warning**: this is experimental / pre-alpha code.



## VM versions

- **mk1** - machine from [Wirth](https://en.wikipedia.org/wiki/Niklaus_Wirth)'s 1976 book [Algorithms + Data Structures = Programs](https://en.wikipedia.org/wiki/Algorithms_%2B_Data_Structures_%3D_Programs)
  - **mk2** - variable number of arguments, swapped a and l
    - **mk3** - internal bytecode version of mk2
      - **abandoned** as bytecode requires more work than fixed-width cells - instructions variants and assembler changes

    - **mk4** - switch call threading version of mk2
    - **mk5** - indirect call threading version of mk2

- **mk6** - register based vm inspired by [smol](https://github.com/mobarski/smol)

- **mk7** - register based vm inspired by [Human Resource Machine](https://store.steampowered.com/app/375820/Human_Resource_Machine/)
  - **mk7c** - mk7 implemented in C (🚧)
  - **mk7ci** - mk7 implementation in C, indirect threading (🚧)
    - **mk7ci2** - mk7ci with acc as register variable (🚧)
  - **mk7cc** - mk7 asm compiled to C code (🚧)




## Quick benchmarking results

|  task  | arg  |   vm   |            src            | code size [cells] | vm cycles | runs | avg time | avg vm cycles / s | cpu cycles / vm cycle | setup |
| :----: | :--: | :----: | :-----------------------: | :---------------: | :-------: | ---- | :------: | :---------------: | :-------------------: | :---: |
| loops3 |  30  |  mk2   | [src](asm/loops3_mk2.asm) |        86         |   279K    | 1000 | 495µs 🥉  |       563M        |         8.53          |   A   |
| loops3 |  30  |  mk4   | [src](asm/loops3_mk2.asm) |        86         |   279K    | 1000 |  619µs   |       451M        |         10.64         |   A   |
| loops3 |  30  |  mk5   | [src](asm/loops3_mk2.asm) |        86         |   279K    | 1000 |  621µs   |       449M        |         10.69         |   A   |
| loops3 |  30  | mk6 🏆  | [src](asm/loops3_mk6.asm) |       51 🥈        |  112K 🥇   | 1000 | 166µs 🥇  |       677M        |         7.09          |   A   |
| loops3 |  30  |  mk7   | [src](asm/loops3_mk7.asm) |       48 🥇        |  142K 🥈   | 1000 | 191µs 🥈  |       742M        |         6.47          |   A   |
|        |      |        |                           |                   |           |      |          |                   |                       |       |
| loops3 | 300  |  mk7   | [src](asm/loops3_mk7.asm) |        48         |   135M    | 30   |  464ms   |       291M        |         16.5          |   A   |
| loops3 | 300  |  mk7c  | [src](asm/loops3_mk7.asm) |        48         |   135M    | 30   |  207ms   |       652M        |          7.4          |   B   |
| loops3 | 300  | mk7ci  | [src](asm/loops3_mk7.asm) |        48         |   135M    | 30   |  110ms   |       1227M       |          3.9          |   B   |
| loops3 | 300  | mk7ci2 | [src](asm/loops3_mk7.asm) |        48         |   135M    | 30   |   96ms   |       1406M       |          3.4          |   B   |
| loops3 | 300  | mk7cc  |                           |        --         |   135M    | 30   |  10,3µs  |      13106G       |        1/2730         |   B   |
| loops3 | 300  | mk7cc  |                           |        --         |   135M    | 30   |  160ms   |       843M        |          5.7          |   C   |

**setup A**: i7-9700K @ 4.8GHz, gcc 11.4.0, Nim 2.0.0, -d:cc -d:release -d:danger --gc:arc

**setup B**: i7-9700K @ 4.8GHz, gcc 11.4.0, -O3

**setup C**: i7-9700K @ 4.8GHz, tcc 0.9.27



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

- `LIT`, `INT`, `LOD`, `STO`
- `CAL`, `JMP`, `JPC`
- `OPR`:
  - `ADD`, `SUB`, `MUL`, `DIV`
  - `RET`, `NEG`, `ODD`, `MOD`
  - `EQ`, `NE`, `LT`, `LE`, `GT`, `GE`
- `EX1`, `EX2`, `EX3`, `EX4`, `EX5`, `EX6`, `EX7`
- `HLT`

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

**DATA TRANSFER**

```
- LIT  a b  ; set memory cell (a) to literal value (b)
- MOV  a b  ; set memory cell (a) to value from memory cell (b)
- PEEK a b  ; set memory cell (a) with value from memory cell indicated by (b)
- POKE a b  ; set memory cell indicated by (a) to value from memory cell (b)
```

**CONTROL FLOW**

```
- JMP  a 0  ; jump to program location (a)
- JZ   a b  ; if memory cell (a) is zero then jump to program location (b)
- JNZ  a b  ; if memory cell (a) is not zero then jump to program location (b)
- CAL  a 0  ; call subroutine at program location (a)
- RET  0 0  ; return from subroutine call
- HLT  0 0  ; halt the program
```

**ALU**

```
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
```

**IO**

```
- PUTC a 0  ; write the value from memory cell (a) to stdout (as character)
- PUTI a 0  ; write the value from memory cell (a) to stdout (as integer)
- GETC a 0  ; read a character from stdin and store it in memory cell (a)
- GETI a 0  ; read an integer from stdin and store it in memory cell (a), skip initial whitespaces
- EOF  a 0  ; set memory cell (a) to 1 if stdin indicates end-of-file or to 0 otherwise
```



### mk7 instruction set

```
- IN  0  ; read input to ACC
- OUT 0  ; write ACC to output
- LDA a  ; load memory cell (a) to ACC
- STA a  ; store ACC in memory cell (a)
- ADD a  ; add memory cell (a) to ACC
- SUB a  ; subtract memory cell (a) from ACC
- INC a  ; increase memory cell (a) by 1
- DEC a  ; decrease memory cell (a) by 1
- JMP a  ; jump to address (a)
- JZ  a  ; jump to address (a) if ACC is zero
- JN  a  ; jump to address (a) if ACC is negative
- LIT a  ; load (a) to ACC
- HLT 0  ; halt the program
```



### mk8 instruction set

mk7 instructions extended with

```
- CAL a ; call procedure at address (a)
- RET 0 ; return from procedure
- LPA a ; load memory cell pointed by (a) to ACC
- SPA a ; store ACC in memory cell pointed by (a)
- ASR a ; arithmetic shift right ACC by (a)
- NOP a ; do nothing, (a) can be used to mark labels

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

- https://en.wikipedia.org/wiki/P-code_machine
- https://github.com/mobarski/vimes
- https://github.com/mobarski/smol
- https://rosettacode.org/wiki/Category:PL/0
- https://rosettacode.org/wiki/Category:XPL0
- http://pascal.hansotten.com/niklaus-wirth/pl0/
- https://github.com/mobarski/vimes/blob/main/references.md



