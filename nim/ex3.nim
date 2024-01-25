proc ex3(a:Cell) = #, s:var openArray[Cell], t:var Cell) =
    case a:
        of INC: s[t] += 1
        of DEC: s[t] -= 1
        of EQZ: s[t]  = ord(s[t] == 0).Cell
        of NEZ: s[t]  = ord(s[t] != 0).Cell
        of LTZ: s[t]  = ord(s[t] <  0).Cell
        of LEZ: s[t]  = ord(s[t] <= 0).Cell
        of GTZ: s[t]  = ord(s[t] >  0).Cell
        of GEZ: s[t]  = ord(s[t] >= 0).Cell
        else: quit("unknown EX3 opcode",1)
