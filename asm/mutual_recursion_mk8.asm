# REF: https://rosettacode.org/wiki/Mutual_recursion
# Hofstadter Female and Male sequences
# argument and result in acc, n saved on a data stack (s)
#
# F(0) = 1 ; F(n) = n - M(F(n-1))
# M(0) = 0 ; M(n) = n - F(M(n-1))
#
# in:  n
# out: F(0)..F(n-1), then M(0)..M(n-1)
# ex:  5 -> 1 1 2 2 3 0 0 1 2 2

# aliases
load=lda
to=sta
call=cal

# variable location
n=2
i=3
tmp=4
s=10   # data stack pointer (grows up)
sb=100 # data stack base

main:
    lit 0 to 0
    lit 1 to 1
    lit sb to s
    in 0 to n
    lit 0 to i
    loop_f: load i sub n jzp f_end
        load i call hof-f out 0
        inc i
        jmp loop_f
    f_end:
    lit 0 to i
    loop_m: load i sub n jzp m_end
        load i call hof-m out 0
        inc i
        jmp loop_m
    m_end:
    hlt 0

(n -- Fn)  # n and the result in acc
hof-f:
    jz .base
    push s           # save n
    sub 1            # n-1
    call hof-f       # F(n-1)
    call hof-m       # M(F(n-1))
    to tmp
    pop s            # n
    sub tmp
    ret 0
    .base:
    lit 1
    ret 0

(n -- Mn)  # n and the result in acc
hof-m:
    jz .base
    push s
    sub 1
    call hof-m       # M(n-1)
    call hof-f       # F(M(n-1))
    to tmp
    pop s
    sub tmp
    ret 0
    .base:
    ret 0            # acc is already 0
