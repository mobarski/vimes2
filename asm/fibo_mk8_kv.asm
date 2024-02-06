# def fib(n)
#   return n if n <= 1
#   fib(n - 1) + fib(n - 2)
# end

# mem
n=0
one=1
two=2
sp=3   # stack pointer
tmp=4

lit 10 sta sp # stack starts at m[10]

in 0 sta n
inc sp spa sp # push
lit 1 sta one
lit 2 sta two
cal fib
lpa sp out 0 # pop print
hlt 0

fib: (n--y)
    lpa sp
    sub one
    jz retn
    lpa sp
    sub one
    jn retn

    lpa sp sub one # n-1
    inc sp spa sp # (n n1)
    cal fib (n y1)

    lda sp sta tmp dec tmp # tmp:sp-1
    lpa tmp sub two   # n-2
    inc sp spa sp # (n y1 n2)
    cal fib (n y1 y2)

    lpa sp dec sp (n y1)
    sta tmp # tmp:y2
    lpa sp dec sp (n)
    add tmp spa sp (y1+y2)

    ret 0

    retn:
        (n--n)
        ret 0
