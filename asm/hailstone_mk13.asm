# REF: https://rosettacode.org/wiki/Hailstone_sequence
#
# print(n); length = 1
# while n != 1:
#     n = n // 2 if n % 2 == 0 else 3*n + 1
#     print(n); length += 1
# print(length)
#
# in:  n
# out: the sequence, then its length
# ex:  7 -> 7 22 11 34 17 52 26 13 40 20 10 5 16 8 4 2 1 17

# aliases (if/then/else read like smol: "if eq i n then end 0")
if=
then=jnz
else=jz
load=lda
to=sta
peek=ldap
poke=stap

# variable location
n=2
len=3
r=4
two=5
three=6

lit 0 0
lit 1 1
lit two 2
lit three 3
get n 0
put n 0
lit len 1
loop: if eq n 1 then end 0
    mov r n  mod r two
    if eq r 0 then even 0
    mul n three  add n 1
    jmp next 0
    even: div n two
    next:
    put n 0
    add len 1
    jmp loop 0
end:
put len 0
hlt 0 0
