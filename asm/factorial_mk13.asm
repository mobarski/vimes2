# REF: https://rosettacode.org/wiki/Factorial
#
# def fact(n):
#     f = 1
#     for i in 2..n: f *= i
#     return f
#
# in:  k, then k numbers (n <= 7 for int16)
# out: n! for each number
# ex:  3 0 5 7 -> 1 120 5040

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
f=4
i=5

lit 0 0
lit 1 1
get k 0
loop: if eq k 0 then end 0
    get n 0
    lit f 1
    lit i 2
    .mul: if gt i n then .done 0
        mul f i
        add i 1
        jmp .mul 0
    .done:
    put f 0
    sub k 1
    jmp loop 0
end:
hlt 0 0
