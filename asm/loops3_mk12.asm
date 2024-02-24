n=2 y=3 i=4 j=5 k=6

load=lda
to=sta

lit 0 to 0
lit 1 to 1

get 0 to n

load n to i
loop1:
    load i jz end1
    dec i
    load n to j
    loop2:
        load j jz end2
        dec j
        load n to k
        loop3:
            load k jz end3
            dec k
            inc y
            jmp loop3 end3:
        jmp loop2 end2:
    jmp loop1 end1:

load y put 0
hlt 0
