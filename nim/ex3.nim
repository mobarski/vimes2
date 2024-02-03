proc ex3(a:Word) = #, s:var openArray[Word], t:var Word) =
    case a:
        of INC: s[t] += 1
        of DEC: s[t] -= 1
        of EQZ: s[t]  = ord(s[t] == 0).Word
        of NEZ: s[t]  = ord(s[t] != 0).Word
        of LTZ: s[t]  = ord(s[t] <  0).Word
        of LEZ: s[t]  = ord(s[t] <= 0).Word
        of GTZ: s[t]  = ord(s[t] >  0).Word
        of GEZ: s[t]  = ord(s[t] >= 0).Word
        else: quit("unknown EX3 opcode",1)
