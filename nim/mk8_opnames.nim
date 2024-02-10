import tables

let opnames = {
    IN:"IN",
    OUT:"OUT",
    LDA:"LDA",
    STA:"STA",
    ADD:"ADD",
    SUB:"SUB",
    INC:"INC",
    DEC:"DEC",
    JMP:"JMP",
    JZ:"JZ",
    JN:"JN",
    # EXTENSION
    LIT:"LIT",
    HLT:"HLT",
    # MK8
    CAL:"CAL",
    RET:"RET",
    LPA:"LPA",
    SPA:"SPA",
    ASR:"ASR",
    NOP:"NOP",
    # EXTENSION
    PUSH:"PUSH",
    POP:"POP",
}.to_table
