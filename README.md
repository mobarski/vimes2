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

- **mk7** - register based vm inspired by [Human Resource Machine](https://store.steampowered.com/app/375820/Human_Resource_Machine/) (TODO)



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

### mk6

- `JZ`, `JNZ`, `CAL`, `RET`, `JMP`
- `LIT`, `MOV`, `PEEK`, `POKE`
- `ADD`, `SUB`, `MUL`, `DIV`, `MOD`, `NEG`
- `EQ`, `NE`, `LT`, `LE`, `GT`, `GE`
- `PUTC`, `PUTI`, `GETC`, `GETI`, `EOF`

### mk7

```
 1. IN  0 : send input to ACC
 2. OUT 0 : send ACC to output
 3. LDA m : load memory cell (m) to ACC
 4. STA m : store ACC in memory cell (m)
 5. ADD i : add (i) to ACC
 6. SUB i : subtract (i) from ACC
 7. INC m : increase memory cell (m) by 1
 8. DEC m : decrease memory cell (m) by 1
 9. JMP a : jump to address (a)
10. JZ  a : jump to address (a) if ACC is zero
11. JN  a : jump to address (a) if ACC is negative

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

