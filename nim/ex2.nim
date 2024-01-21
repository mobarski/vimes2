
proc ex2(a:Cell, s:var openArray[Cell], t:var Cell) =
    case a:
        of PUTC: stdout.write chr(s[t]); t-=1
        of PUTI: stdout.write s[t];      t-=1
        else: assert false, "unknown EX2 opcode"
