# REF: https://rosettacode.org/wiki/Fibonacci_sequence
# iterative version (recursive one: fibo_mk8.asm)
#
# a, b = 0, 1
# for i in 0..n:
#     print(a)
#     a, b = b, a + b
#
# in:  n (n <= 22 for int16)
# out: F(0) .. F(n)
# ex:  10 -> 0 1 1 2 3 5 8 13 21 34 55

# aliases
load=lda
to=sta

# variable location
n=2
a=3
b=4
t=5

main:
    lit 0 to 0
    lit 1 to 1
    in 0 to n
    lit 0 to a
    lit 1 to b
    inc n                 # n+1 numbers
    loop: load n jz end
        load a out 0
        load a add b to t
        load b to a
        load t to b
        dec n
        jmp loop
    end:
    hlt 0
