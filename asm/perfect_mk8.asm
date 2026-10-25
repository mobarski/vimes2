# REF: https://rosettacode.org/wiki/Perfect_numbers
# m is perfect if the sum of its proper divisors equals m
#
# for m in 2..n:
#     s = sum(d for d in 1..m-1 if m % d == 0)
#     if s == m: print(m)
#
# in:  n (keep it small, ie 500 -> about 2M cycles)
# out: perfect numbers <= n
# ex:  500 -> 6 28 496

# aliases
load=lda
to=sta

# variable location
n=2
m=3
s=4
d=5
r=6

main:
    lit 0 to 0
    lit 1 to 1
    in 0 to n
    lit 2 to m
    m_loop: load n sub m jn end
        lit 0 to s
        lit 1 to d
        d_loop: load d sub m jzp d_end    # d >= m
            # r = m % d
            load m to r
            .mod: load r sub d to r jz divisor jp .mod
            jmp next
            divisor: load s add d to s
            next: inc d
            jmp d_loop
        d_end:
        load s sub m jz perfect
        jmp m_next
        perfect: load m out 0
        m_next: inc m
        jmp m_loop
    end:
    hlt 0
