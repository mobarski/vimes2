# mk4: call threading version of mk2

include opcodes
include opnames

include base
include ex1
include ex2
include ex3

proc do_lod(a: Cell, code: openArray[Cell]) =
    let l = code[p]; p+=1
    t+=1; s[t]=s[base(l)+a]
proc do_cal(a: Cell, code: openArray[Cell]) =
    let l = code[p]; p+=1
    s[t+1] = base(l)
    s[t+2] = b
    s[t+3] = p
    b = t + 1
    p = a
proc do_sto(a: Cell, code: openArray[Cell]) =
    let l = code[p]; p+=1
    s[base(l)+a]=s[t]; t-=1

proc do_lit(a: Cell, code: openArray[Cell]) = t+=1; s[t]=a
proc do_int(a: Cell, code: openArray[Cell]) = t+=a
proc do_jmp(a: Cell, code: openArray[Cell]) = p=a
proc do_jpc(a: Cell, code: openArray[Cell]) =
    if s[t]==0:
        p = a
        t -= 1
proc do_opr(a: Cell, code: openArray[Cell]) =
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
        else: quit("unknown OPR opcode",1)

proc run(code: openArray[Cell]) =
    when defined(trace): trace_header()
    while true:
        var i = code[p+0]
        var a = code[p+1]
        var l : Cell # not always used
        
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
