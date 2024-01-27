INT 5 ; var 1:n 2:y 3:i 4:j 5:k
LIT 99

EX1 GETI STO 1 0 ; n = input

LOD 1 0 STO 3 0 ; i = n
loop1:
    LOD 3 0 JPC loop1_end
    LIT 1 OPR SUB
    STO 3 0 ; i = i - 1

    LOD 1 0 STO 4 0 ; j = n
    loop2:
        LOD 4 0 JPC loop2_end
        LIT 1 OPR SUB
        STO 4 0 ; j = j - 1

        LOD 1 0 STO 5 0 ; k = n
        loop3:
            LOD 5 0 JPC loop3_end
            LIT 1 OPR SUB
            STO 5 0 ; k = k - 1
            LOD 2 0 LIT 1 OPR ADD STO 2 0 ; y = y + 1
            JMP loop3
        loop3_end:

        JMP loop2
    loop2_end:
    
    JMP loop1
loop1_end:

LOD 2 0 EX1 PUTI
JMP 0
