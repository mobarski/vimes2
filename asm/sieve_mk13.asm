
n=2
i=3
j=4
a=5
a0=19 # so it looks good in the debug output

then=jnz
else=jz
peek=ldap
poke=stap
load=lda

lit 0 0
lit 1 1
lit a a0

get n 0

# fill the array with ones
lit i 0
loop1:
    (if) eq i n then end1 0
    load 0 1 poke a i
    add i 1
    jmp loop1 0 end1:

lit i 2
loop2:
    (if) eq i n then end2 0
    peek a i jz not_prime 0

    prime:
        put i 0

    not_prime:
        mov j i
        add j i
        loop3:
            (if) ge j n then end3 0
            load 0 0 poke a j
            add j i
            jmp loop3 0 end3:

    add i 1
    jmp loop2 0 end2:

hlt 0 0
