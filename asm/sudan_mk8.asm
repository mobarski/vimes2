# REF: https://en.wikipedia.org/wiki/Sudan_function
# REF: https://rosettacode.org/wiki/Sudan_function

load=lda
to=sta
peek=lpa
poke=spa
s=3 sb=10
z=5 # result
p=6 # pointer for peeking deeper into the stack
n=7
x=8
y=9

lit 0 to 0
lit 1 to 1
lit 2 to 2
lit sb to s

in 0 push s (n)
in 0 push s (x)
in 0 push s (y)

cal sudan
pop s out 0
hlt 0

sudan: (nxy--z)
    peek s (y) jz y_is_0
    load s sub 2 to p peek p (n) jz n_is_0

    otherwise: (nxy--z)
        load s sub 2 to p peek p push s (nxy | n)
        inc p peek p push s             (nxy | n x)
        inc p peek p sub 1 push s       (nxy | n x y-1)
        cal sudan (nxy | z)
        pop s to z (nxy) (z = S[n,x,y-1])
        pop s to y (nxy--nx)
        pop s (nx--n)
        pop s (n) sub 1 push s (n-1)
        load z push s (n-1 z) add y push s (n-1 z z+y) cal sudan
        ret 0

    n_is_0:
        pop s to z (nxy--nx) (z=y)
        pop s add z (nx--n) (acc=x+y)
        poke s (n--x+y)
        ret 0
    
    y_is_0:
        dec s (nxy--nx)
        pop s (nx--n) (acc=x)
        poke s (n--x)
        ret 0
