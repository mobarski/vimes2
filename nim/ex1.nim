
proc ex1(a:Cell, s:var openArray[Cell], t:var Cell) =
    case a:
        of PUTC: stdout.write chr(s[t]); t-=1
        of PUTI: stdout.write s[t];      t-=1
        of GETC: t+=1; s[t] = stdin.read_char.Cell
        of GETI: t+=1; s[t] = read_line(stdin).strip().parse_int().Cell
        else: assert false, "unknown EX2 opcode"
