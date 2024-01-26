; def fib(n)
;   return n if n <= 1
;   fib(n - 1) + fib(n - 2)
; end

INT 0 2              ; var 1:n 2:result
EX1 0 GETI  STO 0 1  ; get n from stdin

CAL 0 fib     ; call fib(n)
LOD 0 2    
EX1 0 PUTI    ; print result
JMP 0 0       ; halt

fib:
    INT 0 3
    INT 0 1  LOD 1 1  STO 0 3                ; var 3:nn = n
    LOD 0 3  LIT 0 1  OPR 0 LE  JPC 0 gt1    ; nn <= 1 ?
             LOD 0 3  STO 1 2   OPR 0 RET    ; result=n
    gt1:
        LOD 0 3  LIT 0 1  OPR 0 SUB  STO 1 1  CAL 1 fib  LOD 1 2 ; fib(n-1)
        LOD 0 3  LIT 0 2  OPR 0 SUB  STO 1 1  CAL 1 fib  LOD 1 2 ; fib(n-2)
        ; add, store result and return
        OPR 0 ADD   STO 1 2
        OPR 0 RET                         
