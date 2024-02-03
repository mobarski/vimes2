; 2:n 3:y 4:i 5:j 6:k
LIT 0 0
LIT 1 1

IN 2 0

MOV 4 2 ; i = n
loop1:
    JZ  loop1_end 4
    SUB 4 1 ; i--
    MOV 5 2 ; j = n
    loop2:
        JZ  loop2_end 5
        SUB 5 1 ; j--
        MOV 6 2 ; k = n
        loop3:
            JZ  loop3_end 6
            SUB 6 1 ; k--
            ADD 3 1 ; y++
        JMP loop3 0
        loop3_end:
    JMP loop2 0
    loop2_end:
JMP loop1 0
loop1_end:

OUT 3 0
HLT 0 0
