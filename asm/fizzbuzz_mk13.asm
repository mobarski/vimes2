# REF: https://rosettacode.org/wiki/FizzBuzz
# PUT prints numbers only: Fizz=-3, Buzz=-5, FizzBuzz=-15
#
# for i in 1..n:
#     if   i % 15 == 0: print(-15)
#     elif i % 3  == 0: print(-3)
#     elif i % 5  == 0: print(-5)
#     else:             print(i)
#
# in:  n
# ex:  15 -> 1 2 -3 4 -5 -3 7 8 -3 -5 11 -3 13 14 -15

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
i=3
r=4
three=5
five=6
fifteen=7
fz=8
bz=9
fb=10

lit 0 0
lit 1 1
lit three 3
lit five 5
lit fifteen 15
lit fz -3
lit bz -5
lit fb -15
get n 0
lit i 1
loop: if gt i n then end 0
    mov r i  mod r fifteen
    if eq r 0 then fizzbuzz 0
    mov r i  mod r three
    if eq r 0 then fizz 0
    mov r i  mod r five
    if eq r 0 then buzz 0
    put i 0
    jmp next 0
    fizzbuzz: put fb 0  jmp next 0
    fizz:     put fz 0  jmp next 0
    buzz:     put bz 0
    next:
    add i 1
    jmp loop 0
end:
hlt 0 0
