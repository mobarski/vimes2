import vimes/sio

# (a,s,t) is 2.5% faster than (a,t) which is 10% faster than (a)
#proc ex1(a:Cell, s:var openArray[Cell], t:var Cell) =
proc ex1(a:Cell, t:var Cell) =
    case a:
        of PUTI: stdout.write s[t]; t-=1
        of PUTC: stdout.write chr(s[t]); t-=1
        of GETI: t+=1; s[t] = sio.read_int().Cell
        of GETC: t+=1; s[t] = sio.read_chr().Cell
        of EOF:  t+=1; s[t] = sio.eof.ord.Cell()
        else: quit("unknown EX1 opcode",1)

# variant for mk5
proc ex1c(a:Cell, code:openArray[Cell]) =
    case a:
        of PUTI: stdout.write s[t]; t-=1
        of PUTC: stdout.write chr(s[t]); t-=1
        of GETI: t+=1; s[t] = sio.read_int().Cell
        of GETC: t+=1; s[t] = sio.read_chr().Cell
        of EOF:  t+=1; s[t] = sio.eof.ord.Cell()
        else: quit("unknown EX1 opcode",1)
