# variables
n=2
y=3
i=4
j=5
k=6

LIT 0 0
LIT 1 1

GET n 0

MOV i n
loop1:
    CMP i 0 JEQ end1 0
    SUB i 1
    MOV j n
    loop2:
        CMP j 0 JEQ end2 0
        SUB j 1
        MOV k n
        loop3:
            CMP k 0 JEQ end3 0
            SUB k 1
            ADD y 1
        JMP loop3 end3:
    JMP loop2 end2:
JMP loop1 end1:

PUT y 0
HLT 0 0
