; def fib(n)
;   return n if n <= 1
;   fib(n - 1) + fib(n - 2)
; end

INT 2 ; var 0:n 1:result
LIT 8 STO 0 0

CAL fib 0
LOD 1 0 EX1 PUTI ; print result
JMP 0 ; halt

fib:
    INT 3
    INT 1 STO 3 0 ; 3:n
    LOD 3 0 LIT 1 OPR LE JPC gt1
        LOD 3 0 STO 1 1 OPR RET ; result=n
    gt1:
        LOD 3 0 LIT 1 OPR SUB STO 0 1 CAL fib 0 LOD 1 1 ; fib(n-1)
        LOD 3 0 LIT 2 OPR SUB STO 0 1 CAL fib 0 LOD 1 1 ; fib(n-2)
        OPR ADD OPR RET

