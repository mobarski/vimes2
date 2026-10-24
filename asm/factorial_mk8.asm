# REF: https://rosettacode.org/wiki/Factorial
# iterative factorial, multiplication by repeated addition
#
# def fact(n):
#     f = 1
#     for i in 2..n: f = f * i
#     return f
#
# in:  k, then k numbers (n <= 7 for int16)
# out: n! for each number
# ex:  3 0 5 7 -> 1 120 5040

# aliases
load=lda
to=sta
call=cal

# variable location
k=2
n=3
f=4
i=5
r=6
c=7

main:
    lit 0 to 0
    lit 1 to 1
    in 0 to k
    loop:
        load k jz end
        in 0 to n
        call fact out 0
        dec k
        jmp loop
    end:
    hlt 0

(n -- acc=n!)
fact:
    lit 1 to f
    lit 2 to i
    .loop: load n sub i jn .done
        # f = f * i  (r = f added i times)
        lit 0 to r
        load i to c
        .mul: load c jz .mul_end
            load r add f to r
            dec c
            jmp .mul .mul_end:
        load r to f
        inc i
        jmp .loop
    .done:
    load f
    ret 0
