import vimes/sio

# (a,s,t) is 2.5% faster than (a,t) which is 10% faster than (a)
#proc ex1(a:Word, s:var openArray[Word], t:var Word) =
proc ex1(a:Word, t:var Word) =
    case a:
        of PUTI: stdout.write s[t]; t-=1
        of PUTC: stdout.write chr(s[t]); t-=1
        of GETI: t+=1; s[t] = sio.read_int().Word
        of GETC: t+=1; s[t] = sio.read_chr().Word
        of EOF:  t+=1; s[t] = sio.eof.ord.Word
        else: quit("unknown EX1 opcode",1)

# variant for mk5
proc ex1c(a:Word, code:openArray[Word]) =
    case a:
        of PUTI: stdout.write s[t]; t-=1
        of PUTC: stdout.write chr(s[t]); t-=1
        of GETI: t+=1; s[t] = sio.read_int().Word
        of GETC: t+=1; s[t] = sio.read_chr().Word
        of EOF:  t+=1; s[t] = sio.eof.ord.Word
        else: quit("unknown EX1 opcode",1)
