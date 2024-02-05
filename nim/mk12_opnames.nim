import tables

let opnames = {
    HLT: "HLT",
    JMP: "JMP",
    CAL: "CAL",
    RET: "RET",
    JZ: "JZ",
    JNZ: "JNZ",
    LIT: "LIT",
    #MOV: "MOV",
    PEEK: "PEEK",
    POKE: "POKE",
    ADD: "ADD",
    SUB: "SUB",
    MOD: "MOD",
    MUL: "MUL",
    DIV: "DIV",
    NEG: "NEG",
    EQ: "EQ",
    NE: "NE",
    LT: "LT",
    GT: "GT",
    LE: "LE",
    GE: "GE",
    PUTI: "PUTI",
    PUTC: "PUTC",
    GETI: "GETI",
    GETC: "GETC",
    EOF: "EOF",
    LDA: "LDA",
    STA: "STA",
}.to_table
