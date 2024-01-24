
proc ex1(a:Cell, s:var openArray[Cell], t:var Cell) =
    case a:
        of PUTI: stdout.write s[t]; t-=1
        of GETI: t+=1; s[t] = read_line(stdin).strip().parse_int().Cell
        of PUTC: stdout.write chr(s[t]); t-=1
        of GETC: t+=1; s[t] = stdin.read_char.Cell
        else: quit("unknown EX1 opcode",1)
