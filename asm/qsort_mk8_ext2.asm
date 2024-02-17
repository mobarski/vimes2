# REF: https://rosettacode.org/wiki/Sorting_algorithms/Quicksort

# function quicksort(array)
#     if length(array) > 1
#         pivot := select any element of array
#         left := first index of array
#         right := last index of array
#         while left ≤ right
#             while array[left] < pivot
#                 left := left + 1
#             while array[right] > pivot
#                 right := right - 1
#             if left ≤ right
#                 swap array[left] with array[right]
#                 left := left + 1
#                 right := right - 1
#         quicksort(array from first index to right)
#         quicksort(array from left to last index)

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
jle=jzn
jgt=jp
jge=jzp

# variable location
n=2
i=3
j=4
a=5
b=6

tmp=8
s=10
left=11
right=12
pivot=13
first=14
last=15
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

    lit array push-s # left
    lit array add n sub 1 push-s # right
    call sort
    call show
    hlt 0

(left right--)
sort:
    # load args from the stack
    pop-s to right to last
    pop-s to left  to first
    # if length(array) > 1
    load right sub left cmp 1 jle sort_end
    # select first element as the pivot
    peek left to pivot
    # while left <= right
    loop1: load left cmp right jgt loop1_end
      # while array[left] < pivot
      loop2: peek left cmp pivot jge loop2_end
        inc left
        jmp loop2 loop2_end:
      # while array[right] > pivot
      loop3: peek right cmp pivot jle loop3_end
        dec right
        jmp loop3 loop3_end:
      # if left <= right
      load left cmp right jgt if1_end
        # swap array[left] and array[right]
        peek left to tmp
        peek right poke left
        load tmp poke right
        inc left 
        dec right
        if1_end:
      jmp loop1 loop1_end:
    # qsort from left to last index - args
      load left push-s
      load last push-s
    # qsort from first index to right - args and call
      load first push-s
      load right push-s
      call sort
    # qsort from left to last index - call
      call sort
    #end
    sort_end:
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
