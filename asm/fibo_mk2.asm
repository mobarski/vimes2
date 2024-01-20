
; http://dada.perl.it/shootout/fibo.html

LIT 10      ; n = number of fibonacci numbers to calculate
INT 1       ; allocate space for n
STO 0 0     ; store n

INT 1       ; allocate space for result

CAL fib 0   ; call main function
JMP 0       ; halt

fib:
LOD 0 1     ; load n from upper stack frame [0]
INT 1 STO 0 ; store n in current stack frame [0]

STO 1 1     ; store n in upper stack frame [1]
OPR RET     ; return


;   	INT 1 STO 0 ; capture n from stack
;   	LOD 0 LIT 2 OPR LT JZ @else ; n < 2
;   		LIT 1 OPR RET ; return 1
;   	else:
;   		LOD 0 LIT 2 OPR SUB CAL fib ; fib(n-2)
;   		LOD 0 LIT 1 OPR SUB CAL fib ; fib(n-1)
;   		OPR ADD OPR RET