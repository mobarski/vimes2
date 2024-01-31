type Instr = enum
    HLT=0
    #
    IN=1
    OUT=2
    LDA=3
    STA=4
    ADD=5
    SUB=6
    INC=7
    DEC=8
    JMP=9
    JZ=10
    JN=11
    # EXTENSION
    LIT=12
