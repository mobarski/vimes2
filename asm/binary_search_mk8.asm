# REF: https://rosettacode.org/wiki/Binary_search
# iterative binary search in a sorted array
#
# def search(a, x):
#     lo, hi = 0, len(a) - 1
#     while lo <= hi:
#         mid = (lo + hi) // 2
#         if   a[mid] == x: return mid
#         elif a[mid] <  x: lo = mid + 1
#         else:             hi = mid - 1
#     return -1
#
# in:  n, n sorted values, k, k queries
# out: index (0-based) of each query or -1
# ex:  5 1 3 5 7 9 3 7 2 10 -> 3 -1 -1

# aliases
load=lda
to=sta
peek=lpa
poke=spa
call=cal

# variable location
n=2
k=3
x=4
lo=5
hi=6
mid=7
ptr=8
base=9
v=10
i=11
array=100

main:
    lit 0 to 0
    lit 1 to 1
    lit array to base
    # read the array
    in 0 to n
    load base to ptr
    load n to i
    read: load i jz read_end
        in 0 poke ptr inc ptr dec i
        jmp read
    read_end:
    # queries
    in 0 to k
    query: load k jz end
        in 0 to x
        call search out 0
        dec k
        jmp query
    end:
    hlt 0

(x -- acc=index|-1)
search:
    lit 0 to lo
    load n sub 1 to hi
    .loop: load hi sub lo jn .not_found
        load lo add hi asr 1 to mid
        load base add mid to ptr
        peek ptr to v
        sub x jz .found jn .go_right
        # a[mid] > x
        load mid sub 1 to hi
        jmp .loop
        .go_right:
        load mid add 1 to lo
        jmp .loop
    .found:
        load mid ret 0
    .not_found:
        lit -1 ret 0
