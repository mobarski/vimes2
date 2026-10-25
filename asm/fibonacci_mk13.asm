# REF: https://rosettacode.org/wiki/Fibonacci_sequence
#
# a, b = 0, 1
# for i in 0..n:
#     print(a)
#     a, b = b, a + b
#
# in:  n (n <= 22 for int16)
# out: F(0) .. F(n)
# ex:  10 -> 0 1 1 2 3 5 8 13 21 34 55

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
a=3
b=4
t=5
i=6

lit 0 0
lit 1 1
get n 0
lit a 0
lit b 1
lit i 0
loop: if gt i n then end 0
    put a 0
    mov t a  add t b
    mov a b  mov b t
    add i 1
    jmp loop 0
end:
hlt 0 0
