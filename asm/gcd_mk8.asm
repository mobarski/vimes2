# REF: https://rosettacode.org/wiki/Greatest_common_divisor
# Euclid's algorithm by subtraction (mk8 has no division)
#
# def gcd(a, b):
#     while a != b:
#         if a > b: a -= b
#         else:     b -= a
#     return a
#
# in:  k, then k pairs a b (a, b > 0)
# out: gcd for each pair
# ex:  2 48 18 7 5 -> 6 1

# aliases
load=lda
to=sta
call=cal

# variable location
k=2
a=3
b=4

main:
    lit 0 to 0
    lit 1 to 1
    in 0 to k
    loop:
        load k jz end
        in 0 to a
        in 0 to b
        call gcd out 0
        dec k
        jmp loop
    end:
    hlt 0

(a b -- acc=gcd)
gcd:
    .loop: load a sub b jz .done jn .b_bigger
        to a              # a = a - b
        jmp .loop
    .b_bigger:
        load b sub a to b # b = b - a
        jmp .loop
    .done:
    load a
    ret 0
