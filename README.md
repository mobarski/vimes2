# p-code virtual machines experimentation sandbox v2



## VM versions

- **mk1** - as close to Wirth's machine as possible
- **mk2** - variable number of arguments, swapped a and l
- **mk3** - internal bytecode version of mk2
- **mk4** - switch call threading version of mk2
- **mk5** - indirect call threading version of mk2



## VM instructions



Base instructions:

- `LIT`, `INT`, `LOD`, `STO`
- `CAL`, `JMP`, `JPC`
- `OPR`:
  - `ADD`, `SUB`, `MUL`, `DIV`
  - `RET`, `NEG`, `ODD`, `MOD`
- `EX1`, `EX2`, `EX3`, `EX4`, `EX5`, `EX6`



Extension 1 - stdio:

- `PUTC`, `PUTI`

- `GETC`, `GETI`

  

Extension 2 - ALU extension (bit ops):

- `AND`, `OR`, `XOR`, `NOT`
- `SHL`, `SHR`, `SAR`



Extension 3 - ALU extension (common ops)

- `INC`, `DEC`
- `EQZ`, `NEZ`, `LTZ`, `LEZ`, `GTZ`, `GEZ`



## Reference materials

- https://en.wikipedia.org/wiki/P-code_machine
- https://github.com/mobarski/vimes
- https://github.com/mobarski/smol
- https://rosettacode.org/wiki/Category:PL/0
- https://rosettacode.org/wiki/Category:XPL0
- http://pascal.hansotten.com/niklaus-wirth/pl0/

