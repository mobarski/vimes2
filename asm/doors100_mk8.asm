# REF: https://rosettacode.org/wiki/100_doors
# naive simulation: pass p toggles every p-th door
#
# doors = [0] * (n+1)
# for p in 1..n:
#     for i in p, 2p, 3p ... <= n:
#         doors[i] = 1 - doors[i]
# print(i for i in 1..n if doors[i])
#
# in:  n (number of doors, ie 100)
# out: numbers of open doors
# ex:  100 -> 1 4 9 16 25 36 49 64 81 100

# aliases
load=lda
to=sta
peek=lpa
poke=spa

# variable location
n=2
p=3
ptr=4
last=5
tmp=6
base=7
i=8
doors=100

main:
    lit 0 to 0
    lit 1 to 1
    lit doors to base
    in 0 to n
    load base add n to last   # address of the last door
    lit 1 to p
    pass: load n sub p jn show
        load base add p to ptr
        toggle: load last sub ptr jn next_pass
            peek ptr to tmp
            lit 1 sub tmp poke ptr   # door = 1 - door
            load ptr add p to ptr
            jmp toggle
        next_pass:
        inc p
        jmp pass
    show:
    lit 1 to i
    load base add 1 to ptr
    show_loop: load n sub i jn end
        peek ptr jz closed
            load i out 0
        closed:
        inc i inc ptr
        jmp show_loop
    end:
    hlt 0
