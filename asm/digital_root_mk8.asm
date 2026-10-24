# REF: https://rosettacode.org/wiki/Digital_root
# additive persistence and digital root (repeated digit sums)
#
# def digital_root(n):
#     p = 0
#     while n >= 10:
#         n = sum_digits(n)
#         p += 1
#     return p, n
#
# in:  k, then k numbers (>= 0)
# out: persistence and root for each number
# ex:  2 9875 627 -> 2 2 2 6

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
p=7

main:
    lit 0 to 0
    lit 1 to 1
    lit 10 to ten
    in 0 to k
    loop:
        load k jz end
        in 0 to n
        lit 0 to p
        .root: load n sub ten jn .root_end
            call sum-digits to n
            inc p
            jmp .root .root_end:
        load p out 0
        load n out 0
        dec k
        jmp loop
    end:
    hlt 0

(n -- acc=sum)  # n is destroyed
sum-digits:
    lit 0 to s
    .outer: load n jz .done
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
