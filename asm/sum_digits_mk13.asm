# REF: https://rosettacode.org/wiki/Sum_digits_of_an_integer
#
# def sum_digits(n):
#     s = 0
#     while n > 0:
#         s += n % 10
#         n //= 10
#     return s
#
# in:  k, then k numbers (>= 0)
# out: digit sum for each number
# ex:  3 1 1234 32767 -> 1 10 25

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
n=3
s=4
r=5
ten=6

lit 0 0
lit 1 1
lit ten 10
get k 0
loop: if eq k 0 then end 0
    get n 0
    lit s 0
    .digits: if eq n 0 then .done 0
        mov r n  mod r ten  add s r
        div n ten
        jmp .digits 0
    .done:
    put s 0
    sub k 1
    jmp loop 0
end:
hlt 0 0
