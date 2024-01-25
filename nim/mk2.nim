# mk2: variable number of arguments, a and l swapped

include opcodes
include opnames

include base
include ex1
include ex2
include ex3

proc run(code : openArray[Cell]) =
    when defined(trace): trace_header()
    while true:
        var i = code[p+0]
        var a = code[p+1]
        var l : Cell # not always used
        
        when defined(cc): cc+=1 # count cycles
        when defined(trace): trace(a,code) # trace execution
        
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
                    of ODD: s[t] = s[t] mod 2
                    of ADD: t-=1; s[t] += s[t+1]
                    of SUB: t-=1; s[t] -= s[t+1]
                    of MUL: t-=1; s[t] *= s[t+1]
                    of DIV: t-=1; s[t] = s[t] div s[t+1]
                    of MOD: t-=1; s[t] = s[t] mod s[t+1]
                    of EQ:  t-=1; s[t] = ord(s[t] == s[t+1]).Cell
                    of NE:  t-=1; s[t] = ord(s[t] != s[t+1]).Cell
                    of LT:  t-=1; s[t] = ord(s[t] <  s[t+1]).Cell
                    of LE:  t-=1; s[t] = ord(s[t] <= s[t+1]).Cell
                    of GT:  t-=1; s[t] = ord(s[t] >  s[t+1]).Cell
                    of GE:  t-=1; s[t] = ord(s[t] >= s[t+1]).Cell
                    else: quit("unknown OPR opcode",1)
            #of EX1: ex1(a,s,t) # 2.5% faster than ex1(a,t)
            of EX1: ex1(a,t) # 10% faster than ex1(a)
            #of EX2: ex2(a)
            #of EX3: ex3(a)
            else: quit("unknown opcode " & $i & " at p=" & $(p-2),1)
        if p == 0: break

# ============================================================

include cli
cli()
