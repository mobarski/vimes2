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

# variables
n=5
i=6
j=7
a=8
ai=9
aj=10
val=11
acc=12
aptr=19
array=20

# aliasses:
call=cal
cmp=sub
jeq=jz
jlt=jn
jgt=jp

main:
    lit 0 0
    lit 1 1
    lit 2 2
    lit aptr array
    call load-data 0
    call sort 0
    call show 0
    hlt 0 0

sort:
    lit i 1
    lit ai array
    add ai 1
    .loop1: mov acc i cmp acc n jeq .end1 acc
        ptm val ai
        mov aj ai
        sub aj 1
        .loop2: mov acc aj cmp acc aptr jlt .end2 acc
                     (and) ptm acc aj cmp acc val jlt .end2 acc jeq .end2 acc
            ptm acc aj
            add aj 1
            mtp aj acc
            sub aj 2
            jmp .loop2 0 .end2:
        add aj 1
        mtp aj val
        sub aj 1
        add i 1 add ai 1 jmp .loop1 0 .end1:
    ret 0 0

load-data:
    in  n 0
    lit a array
    mov i n
    .loop1: jz .end1 i
        in  val 0
        mtp a val
        add a 1
        sub i 1 jmp .loop1 0 .end1:
    ret 0 0

show:
    lit a array
    mov i n
    .loop1: jz .end1 i
        ptm val a
        out val 0
        add a 1
        sub i 1 jmp .loop1 0 .end1:
    ret 0 0
