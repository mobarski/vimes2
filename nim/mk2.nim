# mk2: variable number of arguments, a and l swapped

include base
include opcodes
include ex1
include ex2

proc run(code : openArray[Cell]) =
    while true:
        when defined(cc): cc+=1 # count cycles
        var i = code[p+0]
        var a = code[p+1]
        var l : Cell # not always used
        p += 2

        case i:
            of LIT: t+=1; s[t]=a
            of LOD:
                l = code[p]; p+=1
                t+=1; s[t]=s[base(l)+a]
            of STO:
                l = code[p]; p+=1
                s[base(l)+a]=s[t]; t-=1
            of INT: t+=a
            of JMP: p=a
            of JPC:
                if s[t]==0:
                    p = a
                    t -= 1
            of CAL:
                l = code[p]; p+=1
                s[t+1] = base(l)
                s[t+2] = b
                s[t+3] = p
                b = t + 1
                p = a
            of OPR:
                case a:
                    of RET: t=b-1; p=s[t+3]; b=s[t+2]
                    of NEG: s[t] = -s[t]
                    of ADD: t-=1; s[t] += s[t+1]
                    of SUB: t-=1; s[t] -= s[t+1]
                    of MUL: t-=1; s[t] *= s[t+1]
                    of DIV: t-=1; s[t] = s[t] div s[t+1]
                    of ODD: s[t] = s[t] mod 2
                    of MOD: t-=1; s[t] = s[t] mod s[t+1]
                    of EQ:  t-=1; s[t] = ord(s[t] == s[t+1]).Cell
                    of NE:  t-=1; s[t] = ord(s[t] != s[t+1]).Cell
                    of LT:  t-=1; s[t] = ord(s[t] <  s[t+1]).Cell
                    of LE:  t-=1; s[t] = ord(s[t] <= s[t+1]).Cell
                    of GT:  t-=1; s[t] = ord(s[t] >  s[t+1]).Cell
                    of GE:  t-=1; s[t] = ord(s[t] >= s[t+1]).Cell
                    else: assert false, "unknown OPR opcode"
            of EX1: ex1(a,s,t)
            of EX2: ex2(a,s,t)
            else: assert false, "unknown opcode"
        if p == 0: break

# ============================================================

include cli
cli()
