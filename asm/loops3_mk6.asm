; 2:n 3:y 4:i 5:j 6:k
LIT 0 0
LIT 1 1

GETI 2 0

MOV 4 2 ; i = n
loop1:
    JZ  4 loop1_end
    SUB 4 1 ; i--
    MOV 5 2 ; j = n
    loop2:
        JZ  5 loop2_end
        SUB 5 1 ; j--
        MOV 6 2 ; k = n
        loop3:
            JZ  6 loop3_end
            SUB 6 1 ; k--
            ADD 3 1 ; y++
        JMP loop3
        loop3_end:
    JMP loop2
    loop2_end:
JMP loop1
loop1_end:

PUTI 3 0
JMP 0 0
