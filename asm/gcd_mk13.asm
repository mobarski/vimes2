# REF: https://rosettacode.org/wiki/Greatest_common_divisor
# Euclid's algorithm with MOD (mk13 has mul/div/mod)
#
# def gcd(a, b):
#     while b != 0:
#         a, b = b, a % b
#     return a
#
# in:  k, then k pairs a b (a, b > 0)
# out: gcd for each pair
# ex:  2 48 18 7 5 -> 6 1

# aliases (if/then/else read like smol: "if eq i n then end 0")
if=
then=jnz
else=jz
load=lda
to=sta
peek=ldap
poke=stap

# variable location
k=2
a=3
b=4
t=5

lit 0 0
lit 1 1
get k 0
loop:
    if eq k 0 then end 0
    get a 0
    get b 0
    cal gcd 0
    put a 0
    sub k 1
    jmp loop 0
end:
hlt 0 0

(a b -- a=gcd)
gcd:
    .loop: if eq b 0 then .done 0
        mov t a  mod t b   # t = a % b
        mov a b  mov b t
        jmp .loop 0
    .done:
    ret 0 0
