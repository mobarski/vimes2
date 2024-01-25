import sio

proc ex1(a:Cell) =
    case a:
        of PUTI: stdout.write s[t]; t-=1
        of GETI: t+=1; s[t] = sio.read_int().Cell
        of PUTC: stdout.write chr(s[t]); t-=1
        of GETC: t+=1; s[t] = stdin.read_char.Cell
        else: quit("unknown EX1 opcode",1)

# variant for mk5
proc ex1c(a:Cell, code:openArray[Cell]) =
    case a:
        of PUTI: stdout.write s[t]; t-=1
        of GETI: t+=1; s[t] = sio.read_int().Cell
        of PUTC: stdout.write chr(s[t]); t-=1
        of GETC: t+=1; s[t] = stdin.read_char.Cell
        else: quit("unknown EX1 opcode",1)
