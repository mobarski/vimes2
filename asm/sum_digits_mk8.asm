# REF: https://rosettacode.org/wiki/Sum_digits_of_an_integer
# sum of decimal digits; division by 10 done by repeated subtraction
#
# def sum_digits(n):
#     s = 0
#     while n > 0:
#         n, r = divmod(n, 10)
#         s += r
#     return s
#
# in:  k, then k numbers (>= 0)
# out: digit sum for each number
# ex:  3 1 1234 32767 -> 1 10 25

# aliases
load=lda
to=sta
call=cal

# variable location
k=2
n=3
s=4
q=5
ten=6

main:
    lit 0 to 0
    lit 1 to 1
    lit 10 to ten
    in 0 to k
    loop:
        load k jz end
        in 0 to n
        call sum-digits out 0
        dec k
        jmp loop
    end:
    hlt 0

(n -- acc=sum)  # n is destroyed
sum-digits:
    lit 0 to s
    .outer: load n jz .done
        # q = n / 10 ; n = n % 10
        lit 0 to q
        .div: load n sub ten jn .div_end
            to n inc q
            jmp .div .div_end:
        load s add n to s
        load q to n
        jmp .outer
    .done:
    load s
    ret 0
