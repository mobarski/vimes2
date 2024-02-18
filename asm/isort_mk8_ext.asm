# REF: https://rosettacode.org/wiki/Sorting_algorithms/Insertion_sort

# function insertionSort(array A)
#     for i from 1 to length[A]-1 do
#         value := A[i] 
#         j := i-1
#         while j >= 0 and A[j] > value do
#             A[j+1] := A[j]
#             j := j-1
#         done
#         A[j+1] = value
#     done

# aliases
load=lda
to=sta
peek=lpa
poke=spa
call=cal
# comparison
cmp=sub
jeq=jz
jlt=jn
jgt=jp

# variable location
n=2
i=3
j=4
a=5
b=6

tmp=8
s=10
ai=11
aj=12
ajn=13
first=14
last=15
value=16
array=20
sb=999

# this stack grows down!
push-s=dec,s,poke,s
pop-s=peek,s,inc,s

main:
    lit 0 to 0
    lit 1 to 1
    lit sb to s
    call load-data

    call sort
    call show
    hlt 0

sort:
    lit 1 to i
    # for i from 1 to length[A]-1 do
    .loop1: load i cmp n add 1 jgt .loop1_end
        # value := A[i]
        lit array add i to a peek a to value
        # j = i-1
        load i sub 1 to j
        # while j >= 0 and A[j] > value do
        .loop2: load j cmp 0 jlt .loop2_end  lit array add j to b peek b cmp value jlt .loop2_end jeq .loop2_end
            # A[j+1] := A[j]
            lit array add j add 1 to b
            lit array add j to a peek a poke b
            # j := j-1
            dec j
            jmp .loop2 .loop2_end:
        # A[j+1] = value
        lit array add j add 1 to b
        load value poke b
        # i++
        inc i jmp .loop1 .loop1_end:
    ret 0

load-data:
    in 0 to n
    lit array to a
    load n to i
    load_loop:
        load i jz load_loop_end
        in 0 poke a inc a dec i
        jmp load_loop load_loop_end:
    ret 0


show:
    load n to i
    lit array to a
    show_loop:
        load i jz show_end
        peek a out 0 inc a dec i
        jmp show_loop
    show_end:
    ret 0
