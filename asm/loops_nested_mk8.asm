# REF: https://rosettacode.org/wiki/Loops/Nested
# print a 2D array row by row, stop both loops after the value 20
# (the array is read from stdin instead of random numbers)
#
# for row in a:
#     for x in row:
#         print(x)
#         if x == 20: goto done
# done:
#
# in:  rows cols, then rows*cols values
# out: values up to and including the first 20
# ex:  2 3 1 2 3 20 5 6 -> 1 2 3 20

# aliases
load=lda
to=sta
peek=lpa
poke=spa

# variable location
rows=2
cols=3
i=4
j=5
p=6
twenty=7
array=100

main:
    lit 0 to 0
    lit 1 to 1
    lit 20 to twenty
    in 0 to rows
    in 0 to cols
    # read the array
    lit array to p
    load rows to i
    read_i: load i jz read_end
        load cols to j
        read_j: load j jz read_next
            in 0 poke p inc p
            dec j
            jmp read_j
        read_next: dec i
        jmp read_i
    read_end:
    # print until 20
    lit array to p
    load rows to i
    loop_i: load i jz done
        load cols to j
        loop_j: load j jz next_i
            peek p out 0
            sub twenty jz done   # break out of both loops
            inc p dec j
            jmp loop_j
        next_i: dec i
        jmp loop_i
    done:
    hlt 0
