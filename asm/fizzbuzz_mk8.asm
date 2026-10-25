# REF: https://rosettacode.org/wiki/FizzBuzz
# mk8 OUT prints numbers only: Fizz=-3, Buzz=-5, FizzBuzz=-15
# no division: two countdown counters (c3, c5) replace i%3 and i%5
#
# for i in 1..n:
#     if   i % 15 == 0: print(-15)
#     elif i % 3  == 0: print(-3)
#     elif i % 5  == 0: print(-5)
#     else:             print(i)
#
# in:  n
# out: 1 2 -3 4 -5 -3 7 8 -3 -5 11 -3 13 14 -15 ...
# ex:  15 -> 1 2 -3 4 -5 -3 7 8 -3 -5 11 -3 13 14 -15

# aliases
load=lda
to=sta

# variable location
n=2
i=3
c3=4
c5=5

main:
    lit 0 to 0
    lit 1 to 1
    in 0 to n
    lit 1 to i
    lit 3 to c3
    lit 5 to c5
    loop: load n sub i jn end
        dec c3 dec c5
        load c3 jz fizz
        load c5 jz buzz
        load i out 0
        jmp next
        fizz:
            lit 3 to c3
            load c5 jz fizzbuzz
            lit -3 out 0
            jmp next
        fizzbuzz:
            lit 5 to c5
            lit -15 out 0
            jmp next
        buzz:
            lit 5 to c5
            lit -5 out 0
        next:
        inc i
        jmp loop
    end:
    hlt 0
