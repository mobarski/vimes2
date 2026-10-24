# REF: https://rosettacode.org/wiki/Primality_by_trial_division
#
# def is_prime(n):
#     if n < 2: return 0
#     d = 2
#     while d*d <= n:
#         if n % d == 0: return 0
#         d += 1
#     return 1
#
# in:  k, then k numbers
# out: 1 (prime) or 0 for each number
# ex:  4 1 2 9 97 -> 0 1 0 1

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
d=4
r=5
sq=6
two=7
res=8

lit 0 0
lit 1 1
lit two 2
get k 0
loop: if eq k 0 then end 0
    get n 0
    cal is-prime 0
    put res 0
    sub k 1
    jmp loop 0
end:
hlt 0 0

(n -- res=0|1)
is-prime:
    lit res 0
    if lt n two then .ret 0
    lit d 2
    .loop:
        mov sq d  mul sq d
        if gt sq n then .yes 0
        mov r n  mod r d
        if eq r 0 then .ret 0
        add d 1
        jmp .loop 0
    .yes: lit res 1
    .ret: ret 0 0
