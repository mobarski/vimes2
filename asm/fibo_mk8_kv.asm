# def fib(n)
#   return n if n <= 1
#   fib(n - 1) + fib(n - 2)
# end

# mem 0 -> n
# mem 1 -> a=1
# mem 2 -> b=2
# mem 3 -> tos (top-of-stack) = 10
# mem 4 -> tmp

n:0
one:1
two:2
tos:3
tmp:4

lit 10 sta tos # m[3] = 10

in 0 sta n
inc tos spa tos # push
lit 1 sta one
lit 2 sta two
cal fib
lpa tos out 0 # pop print
hlt 0

fib: (n--y)
    lpa tos
    sub one
    jz retn
    lpa tos
    sub one
    jn retn

    lpa tos sub one # n-1
    inc tos spa tos # (n n1)
    cal fib (n y1)

    lda tos sta tmp dec tmp # tmp:tos-1
    lpa tmp sub two   # n-2
    inc tos spa tos # (n y1 n2)
    cal fib (n y1 y2)

    lpa tos dec tos (n y1)
    sta tmp # tmp:y2
    lpa tos dec tos (n)
    add tmp spa tos (y1+y2)

    ret 0

    retn:
        (n--n)
        ret 0
