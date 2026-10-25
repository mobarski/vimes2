# REF: https://rosettacode.org/wiki/Greatest_common_divisor
# Euclid's algorithm with OPR MOD on the mk2 p-code machine (LOD/STO take: addr level)
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
# NOTE: JPC pops the condition only when it jumps (see nim/mk2.nim)

INT 4               ; var 1:k 2:a 3:b
EX1 GETI STO 1 0    ; k = input
loop:
    LOD 1 0 JPC end             ; k == 0 -> end  (k stays on the stack otherwise)
    LIT 1 OPR SUB STO 1 0       ; k = k - 1
    EX1 GETI STO 2 0            ; a = input
    EX1 GETI STO 3 0            ; b = input
    gcd:
        LOD 3 0 JPC done        ; b == 0 -> done (b stays on the stack otherwise)
        LOD 2 0 LOD 3 0 OPR MOD ; stack: b a%b
        STO 3 0                 ; b = a % b
        STO 2 0                 ; a = old b
        JMP gcd
    done:
    LOD 2 0 EX1 PUTI            ; print a
    LIT 10 EX1 PUTC             ; newline
    JMP loop
end:
HLT 0
