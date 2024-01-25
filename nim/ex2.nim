proc ex2(a:Cell) = #, s:var openArray[Cell], t:var Cell) =
    case a:
        of NOT:       s[t] = ord(not s[t]).Cell
        of AND: t-=1; s[t] = ord(s[t] and s[t+1]).Cell
        of OR:  t-=1; s[t] = ord(s[t] or  s[t+1]).Cell
        of XOR: t-=1; s[t] = ord(s[t] xor s[t+1]).Cell
        of SHL: t-=1; s[t] = s[t] shl s[t+1]
        of SHR: t-=1; s[t] = s[t] shr s[t+1]
        of SAR: t-=1; s[t] = ashr(s[t],s[t+1]).Cell
        else: quit("unknown EX2 opcode",1)
