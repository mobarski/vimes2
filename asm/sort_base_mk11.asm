n=2
i=3
j=4
a=5
t=6
a0=20

peek=ldap
poke=stap
load=lda
to=sta

lit 0 0
lit 1 1
lit a a0

get n 0
cal load-data 0
cal sort 0
cal show 0
hlt 0 0


sort:
    ret 0 0


load-data:
    mov i 0
    .loop1:
        cmp i n jge .end1 0
        get t 0 load t 0 poke a i
        add i 1 jmp .loop1 0 .end1:
    ret 0 0


show:
    mov i 0
    .loop1:
        cmp i n jge .end1 0
        peek a i to t 0 put t 0
        add i 1 jmp .loop1 0 .end1:
    ret 0 0
