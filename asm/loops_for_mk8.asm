# REF: https://rosettacode.org/wiki/Loops/For
# nested for loops; row i has i items (numbers 1..i instead of stars)
#
# for i in 1..n:
#     for j in 1..i:
#         print(j)
#
# in:  n
# out: 1  1 2  1 2 3 ...
# ex:  3 -> 1 1 2 1 2 3

# aliases
load=lda
to=sta

# variable location
n=2
i=3
j=4

main:
    lit 0 to 0
    lit 1 to 1
    in 0 to n
    lit 1 to i
    loop_i: load n sub i jn end
        lit 1 to j
        loop_j: load i sub j jn next_i
            load j out 0
            inc j
            jmp loop_j
        next_i:
        inc i
        jmp loop_i
    end:
    hlt 0
