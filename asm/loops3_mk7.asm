; 0:n 1:y i:2 j:3 k:4
IN 0 STA 0 ; load n

LDA 0 STA 2 ; load n into i
loop1:
    LDA 2 JZ loop1_end ; if i == 0, jump to loop1_end
    DEC 2              ; i--
    LDA 0 STA 3        ; load n into j
    loop2:
        LDA 3 JZ loop2_end ; if j == 0, jump to loop2_end
        DEC 3              ; j--
        LDA 0 STA 4        ; load n into k
        loop3:
            LDA 4 JZ loop3_end ; if k == 0, jump to loop3_end
            DEC 4              ; k--
            INC 1              ; y++
            JMP loop3          ; jump to loop3
        loop3_end:
        JMP loop2          ; jump to loop2
    loop2_end:
    JMP loop1          ; jump to loop1
loop1_end:
LDA 1 OUT 0 ; print y
HLT 0
