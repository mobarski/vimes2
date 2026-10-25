# REF: https://rosettacode.org/wiki/Greatest_common_divisor
# Euclid's algorithm with OPR MOD on the mk1 p-code machine (original PL/0 format: i l a)
#
# def gcd(a, b):
#     while b != 0:
#         a, b = b, a % b
#     return a
#
# in:  k, then k pairs a b (a, b > 0)
# out: gcd for each pair (PUTI writes no separator, so a newline is written with PUTC)
# ex:  2 48 18 7 5 -> 6 1
#
# NOTE: JPC pops the condition only when it jumps (see nim/mk1.nim)
# NOTE: mk1 has no HLT - JMP 0 0 halts

INT 0 4                 ; var 1:k 2:a 3:b
EX1 0 GETI  STO 0 1     ; k = input
loop:
    LOD 0 1  JPC 0 end                      ; k == 0 -> end
    LIT 0 1  OPR 0 SUB  STO 0 1             ; k = k - 1
    EX1 0 GETI  STO 0 2                     ; a = input
    EX1 0 GETI  STO 0 3                     ; b = input
    gcd:
        LOD 0 3  JPC 0 done                 ; b == 0 -> done
        LOD 0 2  LOD 0 3  OPR 0 MOD         ; stack: b a%b
        STO 0 3                             ; b = a % b
        STO 0 2                             ; a = old b
        JMP 0 gcd
    done:
    LOD 0 2  EX1 0 PUTI                     ; print a
    LIT 0 10 EX1 0 PUTC                     ; newline
    JMP 0 loop
end:
JMP 0 0
