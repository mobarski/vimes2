n:2 y:3 i:4 j:5 k:6
COPY:LDA
INTO:STA

LIT 0 INTO 0
LIT 1 INTO 1

GETI 0 INTO n

COPY n INTO i ; i = n
loop1:
    COPY i JZ loop1_end
    DEC i ; i--
    COPY n INTO j ; j = n
    loop2:
        COPY j JZ loop2_end
        DEC j ; j--
        COPY n INTO k ; k = n
        loop3:
            COPY k JZ loop3_end
            DEC k ; k--
            INC y ; y++
        JMP loop3
        loop3_end:
    JMP loop2
    loop2_end:
JMP loop1
loop1_end:

COPY y PUTI 0
HLT 0
