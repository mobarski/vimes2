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

n=3
i=4
j=5
a=6
t=7
v=8
a0=20

if=
then=jnz
else=jz
peek=ldap
poke=stap
load=lda
to=sta

lit 0 0
lit 1 1
lit 2 2
lit a a0

get n 0
cal load-data 0
cal sort 0
cal show 0
hlt 0 0


sort:
    lit i 1
    .loop1:
        if ge i n then .end1 0
        peek a i to v 0
        mov j i
        sub j 1
        .loop2:
            if ge j 0 else .end2 0
            peek a j to t 0
            if gt t v else .end2 0
                peek a j
                add j 1
                poke a j
                sub j 2
            jmp .loop2 0 .end2:
        add j 1
        load v 0 poke a j
        sub j 1
        add i 1 jmp .loop1 0 .end1:
    ret 0 0


load-data:
    mov i 0
    .loop1:
        if ge i n then .end1 0
        get t 0 load t 0 poke a i
        add i 1 jmp .loop1 0 .end1:
    ret 0 0


show:
    mov i 0
    .loop1:
        if ge i n then .end1 0
        peek a i to t 0 put t 0
        add i 1 jmp .loop1 0 .end1:
    ret 0 0
