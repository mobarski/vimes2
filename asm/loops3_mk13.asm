# variables
n=2
y=3
i=4
j=5
k=6

THEN=JNZ
ELSE=JZ

LIT 0 0
LIT 1 1

GET n 0

MOV i n
loop1:
    EQ i 0 THEN end1 0
    SUB i 1
    MOV j n
    loop2:
        EQ j 0 THEN end2 0
        SUB j 1
        MOV k n
        loop3:
            EQ k 0 THEN end3 0
            SUB k 1
            ADD y 1
        JMP loop3 end3:
    JMP loop2 end2:
JMP loop1 end1:

PUT y 0
HLT 0 0
