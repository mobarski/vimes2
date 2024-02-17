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
    # MK8
    CAL=13
    RET=14
    LPA=15
    SPA=16
    ASR=17
    NOP=18
    # EXTENSION
    PUSH=19
    POP=20
    JP=21
