# REF: https://rosettacode.org/wiki/Hailstone_sequence
# Collatz sequence: n -> n/2 if even, 3n+1 if odd, until 1
# (int16: n=27 peaks at 9232, still fine)
#
# def hailstone(n):
#     print(n); length = 1
#     while n != 1:
#         n = n // 2 if n % 2 == 0 else 3*n + 1
#         print(n); length += 1
#     print(length)
#
# in:  n
# out: the sequence, then its length
# ex:  7 -> 7 22 11 34 17 52 26 13 40 20 10 5 16 8 4 2 1 17

# aliases
load=lda
to=sta

# variable location
n=2
len=3
h=4

main:
    lit 0 to 0
    lit 1 to 1
    in 0 to n
    load n out 0
    lit 1 to len
    loop: load n sub 1 jz end
        # h = n / 2 ; even if h + h == n
        load n asr 1 to h
        load h add h sub n jz even
        odd:  load n add n add n add 1 to n   # n = 3n + 1
              jmp next
        even: load h to n
        next: load n out 0
        inc len
        jmp loop
    end:
    load len out 0
    hlt 0
