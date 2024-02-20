# REF: https://rosettacode.org/wiki/Sorting_algorithms/Selection_sort#C

# void selection_sort (int *a, int n) {
#     int i, j, m, t;
#     for (i = 0; i < n; i++) {
#         for (j = i, m = i; j < n; j++) {
#             if (a[j] < a[m]) {
#                 m = j;
#             }
#         }
#         t = a[i];
#         a[i] = a[m];
#         a[m] = t;
#     }
# }

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
m=5
t=6
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
    lit ab add n to an
    lit 0 to i
    # for i=0; i<n; i++
    .loop1: load i cmp n jgt .end jeq .end
        # for j=i, m=i; j<n; j++
        lit ab add i to ai to aj to am
        .loop2: load aj cmp an jgt .end2 jeq .end2
            # if a[j] < a[m] then m=j
            peek am to a
            peek aj cmp a jeq .end3 jgt .end3
                load aj to am
            .end3:
        inc aj jmp .loop2 .end2:
        # t = a[i]
        peek ai to t
        # a[i] = a[m]
        peek am poke ai
        # a[m] = t
        load t poke am
    inc i jmp .loop1 .end:
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
