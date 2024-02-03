# def fib(n)
#   return n if n <= 1
#   fib(n - 1) + fib(n - 2)
# end

# mem 0 -> n
# mem 1 -> a=1
# mem 2 -> b=2
# mem 3 -> tos (top-of-stack) = 10
# mem 4 -> tmp
# mem 5 -> tmp2

geti 0 0   # m[0] = n
lit  1 1  # m[1] = 1
lit  2 2  # m[2] = 2
lit  3 10 # m[3] = 10 (top of stack address)

add 3 1 poke 3 0 # push n (n)
cal fib 0
peek 4 3
puti 4 0
hlt  0 0

fib: (n--y)
    peek 4 3 # 4 = n
    le   4 1 # n<=1
    jnz  4 retn

    peek 4 3
    sub 4 1 add 3 1 poke 3 4 # push n-1 (n n1)
    cal fib 0 (n y1)

    (n y1)
    mov 4 3 sub 4 1 # 4:tos-1
    peek 4 4 # 4:n
    sub 4 2 # 4:n-2
    add 3 1 poke 3 4 # push n-2 (n y1 n2)
    cal fib 0 (n y1 y2)

    peek 4 3 # 4:y2
    sub 3 1
    peek 5 3 # 5:y1
    sub 3 1 
    add 4 5 # 4:y1+y2
    poke 3 4 # (y1+y2)
    ret 0 0

    retn:
        ret 0 0 (n--n)
