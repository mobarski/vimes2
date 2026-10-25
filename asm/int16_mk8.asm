# int16 edge cases: all variants (C switch / token / direct threading, Nim)
# must wrap around the same way (two's complement)
#
# in:  a b
# out: a+b  a-b  -a  a>>1 (arithmetic)
# ex:  32767 1 -> -32768 32766 -32767 16383

# aliases
load=lda
to=sta

# variable location
a=2
b=3
z=4

main:
    lit 0 to 0
    lit 1 to 1
    in 0 to a
    in 0 to b
    load a add b out 0
    load a sub b out 0
    lit 0 sub a out 0
    load a asr 1 out 0
    hlt 0
