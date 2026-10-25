# REF: https://rosettacode.org/wiki/Towers_of_Hanoi
# recursive solution; arguments in fixed cells, saved on a data stack (s)
#
# def move(n, f, t, v):
#     if n == 0: return
#     move(n-1, f, v, t)
#     print(f, t)
#     move(n-1, v, t, f)
#
# in:  n (number of disks)
# out: moves as pairs: from to (pegs 1..3)
# ex:  2 -> 1 2 1 3 2 3

# aliases
load=lda
to=sta
call=cal

# variable location
n=2
f=3
t=4
v=5
tmp=6
s=10   # data stack pointer (grows up, push/pop)
sb=100 # data stack base

main:
    lit 0 to 0
    lit 1 to 1
    lit sb to s
    in 0 to n
    lit 1 to f
    lit 3 to t
    lit 2 to v
    call move
    hlt 0

(n f t v --)
move:
    load n jz .ret
    # save frame
    load n push s
    load f push s
    load t push s
    load v push s
    # move(n-1, f, v, t)
    dec n
    load t to tmp load v to t load tmp to v
    call move
    # restore frame
    pop s to v
    pop s to t
    pop s to f
    pop s to n
    load f out 0
    load t out 0
    # move(n-1, v, t, f) - tail call, nothing to save
    dec n
    load f to tmp load v to f load tmp to v
    call move
    .ret:
    ret 0
