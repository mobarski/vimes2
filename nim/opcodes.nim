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

const # EX1 - ALU
    INC = 1
    DEC = 2
    AND = 3
    OR  = 4
    XOR = 5
    NOT = 6
    SHL = 7
    SHR = 8
    SAR = 9 # ASR vs ASHR vs SAR
    # DUP

const # EX2 - STDIO
    PUTC = 1
    PUTI = 2
