# REF: https://rosettacode.org/wiki/100_doors
#
# doors = [0] * (n+1)
# for p in 1..n:
#     for i in p, 2p, 3p ... <= n:
#         doors[i] = 1 - doors[i]
# print(i for i in 1..n if doors[i])
#
# in:  n (number of doors, ie 100)
# out: numbers of open doors
# ex:  100 -> 1 4 9 16 25 36 49 64 81 100

# aliases (if/then/else read like smol: "if eq i n then end 0")
if=
then=jnz
else=jz
load=lda
to=sta
peek=ldap
poke=stap

# variable location
n=2
p=3
i=4
x=5
t=6
dp=7      # pointer to doors
doors=100

lit 0 0
lit 1 1
lit dp doors
get n 0
lit p 1
pass: if gt p n then show 0
    mov i p
    .toggle: if gt i n then .next 0
        peek dp i  to t 0
        lit x 1  sub x t       # x = 1 - door
        load x 0  poke dp i
        add i p
        jmp .toggle 0
    .next:
    add p 1
    jmp pass 0
show:
    lit i 1
    .loop: if gt i n then end 0
        peek dp i  else .closed 0
        put i 0
        .closed:
        add i 1
        jmp .loop 0
end:
hlt 0 0
