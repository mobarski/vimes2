# mk4: call threading version of mk2

include mk1_opcodes
include mk1_opnames

include base
include ex1
include ex2
include ex3

proc do_lod(a: Word, code: openArray[Word]) =
    let l = code[p]; p+=1
    t+=1; s[t]=s[base(l)+a]
proc do_cal(a: Word, code: openArray[Word]) =
    let l = code[p]; p+=1
    s[t+1] = base(l)
    s[t+2] = b
    s[t+3] = p
    b = t + 1
    p = a
proc do_sto(a: Word, code: openArray[Word]) =
    let l = code[p]; p+=1
    s[base(l)+a]=s[t]; t-=1

proc do_lit(a: Word, code: openArray[Word]) = t+=1; s[t]=a
proc do_int(a: Word, code: openArray[Word]) = t+=a
proc do_jmp(a: Word, code: openArray[Word]) = p=a
proc do_jpc(a: Word, code: openArray[Word]) =
    if s[t]==0:
        p = a
        t -= 1
proc do_opr(a: Word, code: openArray[Word]) =
    case a:
        of RET: t=b-1; p=s[t+3]; b=s[t+2]
        of ADD: t-=1; s[t] += s[t+1]
        of SUB: t-=1; s[t] -= s[t+1]
        of MUL: t-=1; s[t] *= s[t+1]
        of DIV: t-=1; s[t] =  s[t] div s[t+1]
        of MOD: t-=1; s[t] =  s[t] mod s[t+1]
        of ODD:       s[t] =  s[t] mod 2
        of NEG:       s[t] = -s[t]
        of EQ:  t-=1; s[t] = (s[t] == s[t+1]).ord.Word
        of NE:  t-=1; s[t] = (s[t] != s[t+1]).ord.Word
        of LT:  t-=1; s[t] = (s[t] <  s[t+1]).ord.Word
        of LE:  t-=1; s[t] = (s[t] <= s[t+1]).ord.Word
        of GT:  t-=1; s[t] = (s[t] >  s[t+1]).ord.Word
        of GE:  t-=1; s[t] = (s[t] >= s[t+1]).ord.Word
        else: quit("unknown OPR opcode",1)

proc run() =
    when defined(trace): trace_header()
    while true:
        var i = code[p+0]
        var a = code[p+1]
        var l : Word # not always used
        
        when defined(cc): cc+=1 # count cycles
        when defined(trace): trace(a, code) # trace execution
        
        p += 2

        case i:
            of LIT: do_lit(a, code)
            of LOD: do_lod(a, code)
            of STO: do_sto(a, code)
            of INT: do_int(a, code)
            of JMP: do_jmp(a, code)
            of JPC: do_jpc(a, code)
            of CAL: do_cal(a, code)
            of OPR: do_opr(a, code)
            of EX1: ex1(a,t)
            #of EX2: ex2(a,t)
            #of EX3: ex3(a,t)
            else: quit("unknown opcode " & $i & " at p=" & $(p-2),1)
        if p == 0: break

# ============================================================

include cli
cli()
