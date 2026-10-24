# REF: https://rosettacode.org/wiki/Primality_by_trial_division
# trial division by d = 2, 3, ... while d*d <= n
# d*d is tracked incrementally: (d+1)^2 = d^2 + 2d + 1 (mk8 has no mul)
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

# aliases
load=lda
to=sta
call=cal

# variable location
k=2
n=3
d=4
sq=5
r=6
two=7

main:
    lit 0 to 0
    lit 1 to 1
    lit 2 to two
    in 0 to k
    loop:
        load k jz end
        in 0 to n
        call is-prime out 0
        dec k
        jmp loop
    end:
    hlt 0

(n -- acc=0|1)
is-prime:
    load n sub two jn .no
    lit 2 to d
    lit 4 to sq
    .loop: load n sub sq jn .yes   # d*d > n
        # r = n % d (by subtraction)
        load n to r
        .mod: load r sub d to r jz .no jp .mod
        # d*d for d+1
        load sq add d add d add 1 to sq
        inc d
        jmp .loop
    .yes: lit 1 ret 0
    .no:  lit 0 ret 0
