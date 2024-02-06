# def fib(n)
#   return n if n <= 1
#   fib(n - 1) + fib(n - 2)
# end

# commands
store=sta
load=lda
poke=spa
peek=lpa

# mem
n=0
one=1
two=2
sp=3   # stack pointer
tmp=4

lit 10 store sp # stack starts at m[10]

in 0 store n
inc sp poke sp # push
lit 1 store one
lit 2 store two
cal fib
peek sp out 0 # pop print
hlt 0

fib: (n--y)
    peek sp
    sub one
    jz retn
    peek sp
    sub one
    jn retn

    peek sp sub one # n-1
    inc sp poke sp # (n n1)
    cal fib (n y1)

    load sp store tmp dec tmp # tmp:sp-1
    peek tmp sub two   # n-2
    inc sp poke sp # (n y1 n2)
    cal fib (n y1 y2)

    peek sp dec sp (n y1)
    store tmp # tmp:y2
    peek sp dec sp (n)
    add tmp poke sp (y1+y2)

    ret 0

    retn:
        (n--n)
        ret 0
