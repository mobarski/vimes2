# def fib(n)
#   return n if n <= 1
#   fib(n - 1) + fib(n - 2)
# end

# mem 0 -> n
# mem 1 -> a=1
# mem 2 -> b=2
# mem 3 -> tos (top-of-stack) = 10
# mem 4 -> tmp

lit 10 sta 3 # m[3] = 10

in 0 sta 0
inc 3 spa 3 # push
lit 1 sta 1
lit 2 sta 2
cal fib
lpa 3 out 0 # pop print
hlt 0

fib: (n--y)
    lpa 3
    sub 1
    jz retn
    lpa 3
    sub 1
    jn retn

    lpa 3 sub 1 # n-1
    inc 3 spa 3 # (n n1)
    cal fib (n y1)

    lda 3 sta 4 dec 4 # 4:tos-1
    lpa 4 sub 2   # n-2
    inc 3 spa 3   # (n y1 n2)
    cal fib (n y1 y2)

    lpa 3 dec 3 (n y1)
    sta 4 # 4:y2
    lpa 3 dec 3 (n)
    add 4 spa 3 (y1+y2)

    ret 0

    retn:
        (n--n)
        ret 0
