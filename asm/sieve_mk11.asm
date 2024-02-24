
n=2
i=3
j=4
a=5
a0=19 # so it looks good in the debug output

peek=ldap
poke=stap
load=lda
to=sta

lit 0 0
lit 1 1
lit a a0

get n 0

# fill the array with ones
lit i 0
loop1:
    cmp i n jge end1 0
    load 0 1 poke a i
    add i 1
    jmp loop1 0 end1:

lit i 2
loop2:
    cmp i n jge end2 0
    peek a i jeq not_prime 0 # jz=jeq UGLY !!!

    prime:
        put i 0

    not_prime:
        mov j i
        add j i
        loop3:
            cmp j n jge end3 0
            load 0 0 poke a j
            add j i
            jmp loop3 0 end3:

    add i 1
    jmp loop2 0 end2:

hlt 0 0
