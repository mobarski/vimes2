; def fib(n)
;   return n if n <= 1
;   fib(n - 1) + fib(n - 2)
; end

INT 2              ; var 1:n 2:result
EX1 GETI STO 1 0   ; get n from stdin

CAL fib 0          ; call fib(n)
LOD 2 0 EX1 PUTI   ; print result
JMP 0              ; halt

fib:
    INT 3
    INT 1 LOD 1 1 STO 3 0           ; var 3:nn = n
    LOD 3 0 LIT 1 OPR LE JPC gt1    ; nn <= 1 ?
        LOD 3 0 STO 2 1 OPR RET     ; result=n
    gt1:
        LOD 3 0 LIT 1 OPR SUB  STO 1 1 CAL fib 1  LOD 2 1 ; fib(n-1)
        LOD 3 0 LIT 2 OPR SUB  STO 1 1 CAL fib 1  LOD 2 1 ; fib(n-2)
        ; add, store result and return
        OPR ADD STO 2 1
        OPR RET                         
