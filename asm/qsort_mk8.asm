# REF: https://rosettacode.org/wiki/Sorting_algorithms/Quicksort

# aliases
load=lda
to=sta
peek=lpa
poke=spa

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
ab=20
sb=999

# this stack grows down!
push-s=dec,s,poke,s
pop-s=peek,s,inc,s

main:
    lit 0 to 0
    lit 1 to 1
    lit sb to s
    cal load-data

    cal sort
    cal show
    hlt 0

(left right--)
sort:
    pop-s to right
    pop-s to left
    load right sub left jz sort_end
    sub 1 jz sort_end
    lit ab add left to a
    lit ab add right to b
    # select first element as the pivot
    peek a to pivot
    # while left <= right
    loop1: load right sub left jn loop1_end
      # while array[left] < pivot
      loop2: peek a to tmp load pivot sub tmp jn loop2_end 
        inc a
        jmp loop2 loop2_end:
      # while array[right] > pivot
      loop3: peek b sub pivot jn loop3_end
        dec b
        jmp loop3 loop3_end:
      # if left <= right
      load right sub left jn if1_end
        # swap array[left] and array[right]
        peek a to tmp
        peek b poke a
        load tmp poke b
        inc a
        dec b
        if1_end
      jmp loop1 loop1_end:
    # qsort from left to last index - args
      load a sub ab push-s load right push-s
    # qsort from first index to right - args and call
      load left push-s load b sub ab push-s
      cal sort
    # qsort from left to last index - call
      cal sort
    #end
    sort_end:
    ret 0

load-data:
    in 0 to n
    lit ab to a
    load n to i
    load_loop:
        load i jz load_loop_end
        in 0 poke a inc a dec i
        jmp load_loop load_loop_end:
    ret 0


show:
    load n to i
    lit ab to a
    show_loop:
        load i jz show_end
        peek a out 0 inc a dec i
        jmp show_loop
    show_end:
    ret 0
