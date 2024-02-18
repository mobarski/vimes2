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
val=9
array=20

# aliasses:
call=cal


main:
    lit 0 0
    lit 1 1
    call load-data 0
    #call sort 0
    call show 0
    hlt 0 0

sort:
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
