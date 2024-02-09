
into=sta
load=lda
peek=lpa
poke=spa

n=2
i=3 p=4
j=5 q=6
array=19

lit 0 into 0
lit 1 into 1

in 0 into n
load n into i
lit array into p

loop:
    load i jz loop_end
    lit 1 poke p
    dec i
    inc p
    jmp loop loop_end:

#jmp end # TEST point #1 all numbers set to 1

lit 2 into i
lit array add i into p
loop2:
    load n sub i jn end
    peek p jz not_prime
        load i out 0
        # dont zero out the prime number
        load p into q
        load i add i into j # j=2*i
        jmp loop3
    not_prime:

    load p into q
    load i into j
    loop3:
        load n sub j jn loop3_end
        lit array add j into q
        lit 0 poke q
        load j add i into j
        jmp loop3 loop3_end:
    inc p inc i
    jmp loop2

end:
