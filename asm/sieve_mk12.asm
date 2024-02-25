n=2 i=3 j=4 a=5 b=6 a0=19

load=lda
if=lda
to=sta
then=jnz
else=jz

lit 0 to 0
lit 1 to 1

get 0 to n

# fill the array with ones
lit 0  to i
lit a0 to a
loop1:
    if i ge n then end1
    lit 1 poke a
    inc a inc i
    jmp loop1 end1:

lit 2  to i
lit a0 add i to a
loop2:
    if i ge n then end2
    peek a jz not_prime

    prime:
        load i put 0

    not_prime:
        load i add i to j
        lit a0 add j to b
        loop3:
            if j ge n then end3
            lit 0 poke b
            load j add i to j
            load b add i to b
            jmp loop3 end3:

    inc i inc a
    jmp loop2 end2:

hlt 0
