# aliases
load=lda
to=sta
peek=lpa
poke=spa

# variable location
n=2
i=3
cnt=4
chg=5
tmp=6
x=7
y=8
a=9
ab=10

main:
    lit 0 to 0
    lit 1 to 1
    cal load-data
    cal sort
    cal show
    hlt 0


sort:
    load n to cnt
    loop2:
        load cnt sub 1 jz sort_end # if item_count <= 1: return
        #
        dec cnt
        lit 0 to chg
        lit ab to a
        load cnt to i
        loop3:
            load i jz loop3_end
            #
            peek a to x inc a
            peek a to y
            #
            load x sub y
            jn dont_swap
                #swap_xy
                dec a load y poke a
                inc a load x poke a
                lit 1 to chg
            dont_swap:
            dec i
            jmp loop3 loop3_end:

        load chg jz sort_end
        jmp loop2
    sort_end:
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
