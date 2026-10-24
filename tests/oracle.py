#!/usr/bin/env python3
# Reference implementations (oracle) for test cases.
# Each function takes a list of input ints and returns a list of output ints.
# Expected outputs are computed here, NOT by the VMs, so a test catches bugs
# both in the asm program and in the machine.

def _ints(xs): return [int(x) for x in xs]

# === existing benchmark programs =============================================

def fibo(inp):            # recursive fib(n)
    n, = inp
    a, b = 0, 1
    for _ in range(n): a, b = b, a+b
    return [a]

def ackermann(inp):
    import sys; sys.setrecursionlimit(100000)
    def A(m, n):
        if m == 0: return n+1
        if n == 0: return A(m-1, 1)
        return A(m-1, A(m, n-1))
    return [A(*inp)]

def sudan(inp):
    def F(n, x, y):
        if n == 0: return x+y
        if y == 0: return x
        return F(n-1, F(n, x, y-1), F(n, x, y-1)+y)
    return [F(*inp)]

def sieve(inp):           # primes in 2..n-1
    n, = inp
    return [i for i in range(2, n) if all(i % d for d in range(2, int(i**0.5)+1))]

def loops3(inp):          # nested loops, n^3 increments
    n, = inp
    return [n*n*n]

def sort(inp):            # n, then n values
    n, *xs = inp
    return sorted(xs[:n])

def _i16(x): return (x + 0x8000) % 0x10000 - 0x8000

def int16(inp):           # a+b a-b -a a>>1 with int16 wrap-around
    a, b = inp
    return [_i16(a+b), _i16(a-b), _i16(-a), _i16(a) >> 1]

# === Rosetta Code tasks (int16 adaptations) ==================================

def loops_for(inp):       # rows 1..n, row i = 1..i (numbers instead of stars)
    n, = inp
    return [j for i in range(1, n+1) for j in range(1, i+1)]

def loops_nested(inp):    # rows cols values...; print until 20 (inclusive)
    r, c, *xs = inp
    out = []
    for v in xs[:r*c]:
        out.append(v)
        if v == 20: break
    return out

def fizzbuzz(inp):        # Fizz=-3 Buzz=-5 FizzBuzz=-15
    n, = inp
    out = []
    for i in range(1, n+1):
        out.append(-15 if i % 15 == 0 else -3 if i % 3 == 0 else -5 if i % 5 == 0 else i)
    return out

def gcd(inp):             # k, then k pairs
    from math import gcd as g
    k, *xs = inp
    return [g(xs[2*i], xs[2*i+1]) for i in range(k)]

def sum_digits(inp):      # k, then k numbers
    k, *xs = inp
    return [sum(int(d) for d in str(x)) for x in xs[:k]]

def digital_root(inp):    # k, then k numbers -> persistence, root
    k, *xs = inp
    out = []
    for x in xs[:k]:
        p = 0
        while x >= 10:
            x = sum(int(d) for d in str(x)); p += 1
        out += [p, x]
    return out

def _is_prime(n):
    return n >= 2 and all(n % d for d in range(2, int(n**0.5)+1))

def primality(inp):       # k, then k numbers -> 1/0
    k, *xs = inp
    return [int(_is_prime(x)) for x in xs[:k]]

def perfect(inp):         # perfect numbers <= n
    n, = inp
    return [m for m in range(2, n+1) if sum(d for d in range(1, m) if m % d == 0) == m]

def hailstone(inp):       # sequence, then its length
    n, = inp
    seq = [n]
    while n != 1:
        n = n//2 if n % 2 == 0 else 3*n+1
        seq.append(n)
    return seq + [len(seq)]

def fibonacci(inp):       # F(0)..F(n), iterative
    n, = inp
    out, a, b = [], 0, 1
    for _ in range(n+1):
        out.append(a); a, b = b, a+b
    return out

def hanoi(inp):           # moves (from to), pegs 1..3
    n, = inp
    out = []
    def move(n, f, t, v):
        if n == 0: return
        move(n-1, f, v, t)
        out.extend([f, t])
        move(n-1, v, t, f)
    move(n, 1, 3, 2)
    return out

def doors100(inp):        # open doors after n passes
    n, = inp
    return [i for i in range(1, n+1) if int(i**0.5)**2 == i]

def binary_search(inp):   # n, n sorted values, k, k queries -> index or -1
    n, *rest = inp
    xs, (k, *qs) = rest[:n], rest[n:]
    return [xs.index(q) if q in xs else -1 for q in qs[:k]]

def factorial(inp):       # k, then k numbers (n <= 7)
    from math import factorial as f
    k, *xs = inp
    return [f(x) for x in xs[:k]]

def mutual_recursion(inp):  # Hofstadter F(0..n-1), then M(0..n-1)
    n, = inp
    def Fn(i): return 1 if i == 0 else i - Mn(Fn(i-1))
    def Mn(i): return 0 if i == 0 else i - Fn(Mn(i-1))
    return [Fn(i) for i in range(n)] + [Mn(i) for i in range(n)]

ORACLES = {k: v for k, v in globals().items() if callable(v) and not k.startswith('_')}

if __name__ == "__main__":
    import sys
    name = sys.argv[1]
    inp = _ints(sys.stdin.read().split())
    print(' '.join(map(str, ORACLES[name](inp))))
