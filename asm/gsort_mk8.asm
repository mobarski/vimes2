# REF: https://rosettacode.org/wiki/Sorting_algorithms/Gnome_sort

# function gnomeSort(a[0..size-1])
#     i := 1
#     j := 2
#     while i < size do
#         if a[i-1] <= a[i] then
#             // for descending sort, use >= for comparison
#             i := j
#             j := j + 1 
#         else
#             swap a[i-1] and a[i]
#             i := i - 1
#             if i = 0 then
#                 i := j
#                 j := j + 1
#             endif
#         endif
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
a=9
b=10
ai=11
aj=12
am=13
an=14
ab=20

main:
    lit 0 to 0
    lit 1 to 1
    call load-data
    call sort
    call show
    hlt 0


sort:
    lit ab to ai inc ai
    lit ab to aj inc aj inc aj
    lit ab add n to an
    .loop1: load ai cmp an jeq .end1 jgt .end1
        dec ai peek ai to a inc ai
        peek ai cmp a jlt .else
            load aj to ai
            inc aj
            jmp .end2
        .else:
            peek ai to a
            dec ai peek ai to b load a poke ai
            inc ai load b poke ai
            dec ai
            load ai cmp ab jn .end2 jp .end2
                load aj to ai
                inc aj
            load 
        .end2:
    jmp .loop1 .end1:
    ret 0


load-data:
    in 0 to n
    lit ab to a
    load n to i
    loop:
        load i jz loop_end
        in 0 poke a inc a dec i
        jmp loop loop_end:
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
