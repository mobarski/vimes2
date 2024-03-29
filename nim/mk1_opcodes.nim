const
    HLT = 0

const
    LIT = 1
    OPR = 2
    LOD = 3
    STO = 4
    CAL = 5
    INT = 6
    JMP = 7
    JPC = 8
    # EXTENSIONS
    EX1 = 9 #
    EX2 = 10 #
    EX3 = 11 #
    EX4 = 12 #
    EX5 = 13 #
    EX6 = 14 #
    EX7 = 15 #
    # mk3
    LIT2 = 17
    CAL2 = 21
    JMP2 = 23
    JPC2 = 24

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

const # EX1 - SIO / STDIO
    PUTI = 1
    GETI = 2
    PUTC = 3
    GETC = 4
    EOF  = 5

const # EX2 - BIT / ALU EXTENSION
    NOT = 1
    AND = 2
    OR  = 3
    XOR = 4
    SHL = 5
    SHR = 6
    SAR = 7 # ASR vs ASHR vs SAR

const # EX3 - ALU EXTENSION
    INC = 1
    DEC = 2
    EQZ = 3
    NEZ = 4
    LTZ = 5
    LEZ = 6
    GTZ = 7
    GEZ = 8
