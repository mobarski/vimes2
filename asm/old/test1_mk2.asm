; repeat printing selected character many times

INT 2          ; var c:1 i:2
LIT 42 STO 1 0 ; c='*'
LIT 40 STO 2 0 ; i=40

repeat:

    LOD 1 0 EX1 PUTC           ; putc c
    LOD 2 0 LIT 1 OPR SUB      ; i-1
    JPC end STO 2 0 JMP repeat ; until i==0

end:
    ; INT -1
    JMP 0 ; halt
