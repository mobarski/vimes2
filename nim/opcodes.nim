const
    LIT = 1
    OPR = 2
    LOD = 3
    STO = 4
    CAL = 5
    INT = 6
    JMP = 7
    JPC = 8
    # mk3
    LIT2 = 9
    CAL2 = 10
    JMP2 = 11
    JPC2 = 12
    # EXTENSIONS
    EX1 = 17 # ALU
    EX2 = 18 # STDIO
    EX3 = 19 # FOR FUTURE USE
    EX4 = 20 # FOR FUTURE USE

const # OPR
    RET = 0
    NEG = 1
    ADD = 2
    SUB = 3
    MUL = 4
    DIV = 5
    ODD = 6
    MOD = 7
    # CMP
    EQ  = 8
    NE  = 9
    LT  = 10
    LE  = 11
    GT  = 12
    GE  = 13

const # EX1 - STDIO
    PUTC = 1
    PUTI = 2
    GETC = 3
    GETI = 4

const # EX2 - ALU EXTENSION
    NOT = 1
    AND = 2
    OR  = 3
    XOR = 4
    SHL = 5
    SHR = 6
    SAR = 7 # ASR vs ASHR vs SAR
    INC = 8
    DEC = 9
    EQZ = 10
    NEZ = 11
    LTZ = 12
    LEZ = 13
    GTZ = 14
    GEZ = 15
    # DUP DROP SWAP OVER ROT ???
