# Vimes2 benchmarking results



## Tasks

- loops:
  - **loops3** - nested loops (similar to: http://dada.perl.it/shootout/nestedloop_details.html)
  - **sieve** - Sieve of Eratosthenes (https://rosettacode.org/wiki/Sieve_of_Eratosthenes)

- recurrency:

  - **fibo** - Fibonacci sequence (https://rosettacode.org/wiki/Fibonacci_sequence)
  - **acker** - Ackermann function (https://rosettacode.org/wiki/Ackermann_function)

  - **sudan** - Sudan function (https://rosettacode.org/wiki/Sudan_function)

- sorting:
  - 🌱 **bsort** - Buttle sort https://rosettacode.org/wiki/Sorting_algorithms/Bubble_sort
  - 🌱 **isort** - Insertion sort (https://rosettacode.org/wiki/Sorting_algorithms/Insertion_sort)
  - 🌱 **gsort** - Gnome sort (https://rosettacode.org/wiki/Sorting_algorithms/Gnome_sort)
  - 🌱 **ssort** - Shell sort (https://rosettacode.org/wiki/Sorting_algorithms/Shell_sort)
  - 🌱 **qsort** - Quick sort (https://rosettacode.org/wiki/Sorting_algorithms/Quicksort)
  - 🌱 **msort** - Merge sort (https://rosettacode.org/wiki/Sorting_algorithms/Merge_sort)



## Results



|  task  | args |           vm            |            src             | code size [words] | vm cycles | runs | avg time | avg vm cycles / s | cpu cycles / vm cycle | setup |
| :----: | :--: | :---------------------: | :------------------------: | :---------------: | :-------: | ---- | :------: | :---------------: | :-------------------: | :---: |
| loops3 |  30  |   [mk2](nim/mk2.nim)    | [src](asm/loops3_mk2.asm)  |        86         |   279K    | 1000 |  495µs   |       563M        |         8.53          |   A   |
| loops3 |  30  |   [mk4](nim/mk4.nim)    | [src](asm/loops3_mk2.asm)  |        86         |   279K    | 1000 |  619µs   |       451M        |         10.64         |   A   |
| loops3 |  30  |   [mk5](nim/mk5.nim)    | [src](asm/loops3_mk2.asm)  |        86         |   279K    | 1000 |  621µs   |       449M        |         10.69         |   A   |
| loops3 |  30  |  [mk6](nim/mk6.nim) 🏆   | [src](asm/loops3_mk6.asm)  |       51 🥈        |  112K 🥇   | 1000 | 166µs 🥇  |       677M        |         7.09          |   A   |
| loops3 |  30  |   [mk7](nim/mk7.nim)    | [src](asm/loops3_mk7.asm)  |       48 🥇        |  142K 🥈   | 1000 | 175µs 🥈  |       813M        |          5.9          |   A   |
| loops3 |  30  |   [mk9](nim/mk9.nim)    | [src](asm/loops3_mk9.asm)  |        54         |   112K🥇   | 1000 | 175µs 🥈  |       640M        |          7.5          |   A   |
| loops3 |  30  |  [mk12](nim/mk12.nim)   | [src](asm/loops3_mk12.asm) |        56         |   142k    | 1000 |  235µs   |       606M        |          7.9          |   A   |
|        |      |                         |                            |                   |           |      |          |                   |                       |       |
|  fibo  |  20  |   [mk1](nim/mk1.nim)    |  [src](asm/fibo_mk1.asm)   |        99         |   372K    | 1000 |  878µs   |       878M        |          5.5          |   A   |
|  fibo  |  20  |   [mk6](nim/mk6.nim)    |  [src](asm/fibo_mk6.asm)   |        99         |   284K    | 1000 |  490µs   |       580M        |          8.3          |   A   |
|  fibo  |  20  |   [mk8](nim/mk8.nim)    |  [src](asm/fibo_mk8.asm)   |        84         |   352K    | 1000 |  467µs   |       752M        |          6.4          |   A   |
|  fibo  |  20  |  [mk10](nim/mk10.nim)   |  [src](asm/fibo_mk10.asm)  |        96         |   278K    | 1000 |  484µs   |       573M        |          8.4          |   A   |
|        |      |                         |                            |                   |           |      |          |                   |                       |       |
| loops3 | 300  |   [mk7](nim/mk7.nim)    | [src](asm/loops3_mk7.asm)  |        48         |   135M    | 30   |  464ms   |       291M        |         16.5          |   A   |
| loops3 | 300  |    [mk7c](c/mk7c.c)     | [src](asm/loops3_mk7.asm)  |        48         |   135M    | 30   |  207ms   |       652M        |          7.4          |   B   |
| loops3 | 300  |    [mk7c](c/mk7c.c)     | [src](asm/loops3_mk7.asm)  |        48         |   135M    | 30   |  167ms   |       808M        |          5.9          |   D   |
| loops3 | 300  |   [mk7ci](c/mk7ci.c)    | [src](asm/loops3_mk7.asm)  |        48         |   135M    | 30   |   86ms   |       1570M       |          3.1          |   B   |
| loops3 | 300  |   [mk7ci](c/mk7ci.c)    | [src](asm/loops3_mk7.asm)  |        48         |   135M    | 30   |  111ms   |       1215M       |          3.9          |   D   |
| loops3 | 300  |   [mk7cd](c/mk7cd.c)    | [src](asm/loops3_mk7.asm)  |        48         |   135M    | 30   |   80ms   |       1687M       |          2.9          |   B   |
| loops3 | 300  |   [mk7cd](c/mk7cd.c)    | [src](asm/loops3_mk7.asm)  |        48         |   135M    | 30   |  112ms   |       1205M       |          3.9          |   D   |
| loops3 | 300  | [mk7cc](c/mk7cc-ugly.c) |                            |        --         |   135M    | 30K  |  6.4µs⚡  |       21T⚡        |         1/4k⚡         |   B   |
| loops3 | 300  | [mk7cc](c/mk7cc-ugly.c) |                            |        --         |   135M    | 30K  |  0.8µs⚡  |       168T⚡       |        1/35k⚡         |   D   |
| loops3 | 300  | [mk7cc](c/mk7cc-ugly.c) |                            |        --         |   135M    | 30   |  160ms   |       843M        |          5.7          |   C   |
|        |      |                         |                            |                   |           |      |          |                   |                       |       |
| sieve  | 900  |   [mk8](nim/mk8.nim)    |  [src](asm/sieve_mk8.asm)  |                   |    83K    | 1K   |  134µs   |       619M        |                       |   A   |
| sieve  | 900  |    [mk8c](c/mk8c.c)     |  [src](asm/sieve_mk8.asm)  |                   |    83K    | 1K   |  107µs   |       775M        |                       |   B   |
| sieve  | 900  |    [mk8c](c/mk8c.c)     |  [src](asm/sieve_mk8.asm)  |                   |    83K    | 1K   |  313µs   |       265M        |                       |   C   |
| sieve  | 900  |    [mk8c](c/mk8c.c)     |  [src](asm/sieve_mk8.asm)  |                   |    83K    | 1K   |  141µs   |       588M        |                       |   D   |
|        |      |                         |                            |                   |           |      |          |                   |                       |       |
| acker  | 3,7  |   [mk8](nim/mk8.nim)    |                            |                   |   12.8M   | 100  |  15.2ms  |       847M        |                       |   A   |
| acker  | 3,7  |    [mk8c](c/mk8c.c)     |                            |                   |   12.8M   | 100  |  15.6ms  |                   |                       |   B   |
| acker  | 3,7  |    [mk8c](c/mk8c.c)     |                            |                   |   12.8M   | 100  |   49ms   |                   |                       |   C   |
| acker  | 3,7  |    [mk8c](c/mk8c.c)     |                            |                   |   12.8M   | 100  |   20ms   |                   |                       |   D   |
|        |      |                         |                            |                   |           |      |          |                   |                       |       |

**setup A**: i7-9700K @ 4.8GHz, gcc 11.4.0, **nim 2.0.0**, -d:cc -d:release -d:danger --gc:arc

**setup B**: i7-9700K @ 4.8GHz, **gcc 11.4.0**, -O3

**setup C**: i7-9700K @ 4.8GHz, **tcc 0.9.27**

**setup D**: i7-9700K @ 4.8GHz, **zig 0.11.0**, cc -O3