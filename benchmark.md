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
  - **qsort** - Quick sort (https://rosettacode.org/wiki/Sorting_algorithms/Quicksort)
  - **isort** - Insertion sort (https://rosettacode.org/wiki/Sorting_algorithms/Insertion_sort)
  - **ssort** - Selection sort (https://rosettacode.org/wiki/Sorting_algorithms/Selection_sort)
  - **bsort** - Bubble sort https://rosettacode.org/wiki/Sorting_algorithms/Bubble_sort
  - 🚧 **gsort** - Gnome sort (https://rosettacode.org/wiki/Sorting_algorithms/Gnome_sort)
  - 🌱 **msort** - Merge sort (https://rosettacode.org/wiki/Sorting_algorithms/Merge_sort)



## Results



|  task  |   args    |           vm            |               src                | vm cycles | runs | avg time | avg vm cycles / s | cpu cycles / vm cycle | setup |
| :----: | :-------: | :---------------------: | :------------------------------: | :-------: | ---- | :------: | :---------------: | :-------------------: | :---: |
| loops3 |    30     |   [mk2](nim/mk2.nim)    |    [src](asm/loops3_mk2.asm)     |   279K    | 1000 |  495µs   |       563M        |         8.53          |   A   |
| loops3 |    30     |   [mk4](nim/mk4.nim)    |    [src](asm/loops3_mk2.asm)     |   279K    | 1000 |  619µs   |       451M        |         10.64         |   A   |
| loops3 |    30     |   [mk5](nim/mk5.nim)    |    [src](asm/loops3_mk2.asm)     |   279K    | 1000 |  621µs   |       449M        |         10.69         |   A   |
| loops3 |    30     |  [mk6](nim/mk6.nim) 🏆   |    [src](asm/loops3_mk6.asm)     |  112K 🥇   | 1000 | 166µs 🥇  |       677M        |         7.09          |   A   |
| loops3 |    30     |   [mk7](nim/mk7.nim)    |    [src](asm/loops3_mk7.asm)     |  142K 🥈   | 1000 | 175µs 🥈  |       813M        |          5.9          |   A   |
| loops3 |    30     |   [mk9](nim/mk9.nim)    |    [src](asm/loops3_mk9.asm)     |   112K🥇   | 1000 | 175µs 🥈  |       640M        |          7.5          |   A   |
| loops3 |    30     |  [mk11](nim/mk11.nim)   |    [src](asm/loops3_mk11.asm)    |   142K    | 1000 |  190µs   |       742M        |                       |   A   |
| loops3 |    30     |  [mk12](nim/mk12.nim)   |    [src](asm/loops3_mk12.asm)    |   142K    | 1000 |  235µs   |       606M        |          7.9          |   A   |
| loops3 |    30     |  [mk13](nim/mk13.nim)   |    [src](asm/loops3_mk13.asm)    |   142K    | 1000 |  206µs   |       684M        |                       |   A   |
|        |           |                         |                                  |           |      |          |                   |                       |       |
|  fibo  |    20     |   [mk1](nim/mk1.nim)    |     [src](asm/fibo_mk1.asm)      |   372K    | 1000 |  878µs   |       878M        |          5.5          |   A   |
|  fibo  |    20     |   [mk6](nim/mk6.nim)    |     [src](asm/fibo_mk6.asm)      |   284K    | 1000 |  490µs   |       580M        |          8.3          |   A   |
|  fibo  |    20     |   [mk8](nim/mk8.nim)    |     [src](asm/fibo_mk8.asm)      |   352K    | 1000 |  467µs   |       752M        |          6.4          |   A   |
|  fibo  |    20     |  [mk10](nim/mk10.nim)   |     [src](asm/fibo_mk10.asm)     |   278K    | 1000 |  484µs   |       573M        |          8.4          |   A   |
|        |           |                         |                                  |           |      |          |                   |                       |       |
| loops3 |    300    |   [mk7](nim/mk7.nim)    |    [src](asm/loops3_mk7.asm)     |   135M    | 30   |  464ms   |       291M        |         16.5          |   A   |
| loops3 |    300    |    [mk7c](c/mk7c.c)     |    [src](asm/loops3_mk7.asm)     |   135M    | 30   |  207ms   |       652M        |          7.4          |   B   |
| loops3 |    300    |    [mk7c](c/mk7c.c)     |    [src](asm/loops3_mk7.asm)     |   135M    | 30   |  167ms   |       808M        |          5.9          |   D   |
| loops3 |    300    |   [mk7ci](c/mk7ci.c)    |    [src](asm/loops3_mk7.asm)     |   135M    | 30   |   86ms   |       1570M       |         3.1 🥈         |   B   |
| loops3 |    300    |   [mk7ci](c/mk7ci.c)    |    [src](asm/loops3_mk7.asm)     |   135M    | 30   |  111ms   |       1215M       |          3.9          |   D   |
| loops3 |    300    |   [mk7cd](c/mk7cd.c)    |    [src](asm/loops3_mk7.asm)     |   135M    | 30   |   80ms   |       1687M       |         2.9 🥇         |   B   |
| loops3 |    300    |   [mk7cd](c/mk7cd.c)    |    [src](asm/loops3_mk7.asm)     |   135M    | 30   |  112ms   |       1205M       |          3.9          |   D   |
| loops3 |    300    | [mk7cc](c/mk7cc-ugly.c) |                                  |   135M    | 30K  |  6.4µs⚡  |       21T⚡        |         1/4k⚡         |   B   |
| loops3 |    300    | [mk7cc](c/mk7cc-ugly.c) |                                  |   135M    | 30K  |  0.8µs⚡  |       168T⚡       |        1/35k⚡         |   D   |
| loops3 |    300    | [mk7cc](c/mk7cc-ugly.c) |                                  |   135M    | 30   |  160ms   |       843M        |          5.7          |   C   |
|        |           |                         |                                  |           |      |          |                   |                       |       |
| sieve  |    900    |   [mk8](nim/mk8.nim)    |     [src](asm/sieve_mk8.asm)     |    83K    | 1K   |  134µs   |       619M        |          7.7          |   A   |
| sieve  |    900    |    [mk8c](c/mk8c.c)     |     [src](asm/sieve_mk8.asm)     |    83K    | 1K   |  107µs   |       775M        |          6.2          |   B   |
| sieve  |    900    |    [mk8c](c/mk8c.c)     |     [src](asm/sieve_mk8.asm)     |    83K    | 1K   |  313µs   |       265M        |          18           |   C   |
| sieve  |    900    |    [mk8c](c/mk8c.c)     |     [src](asm/sieve_mk8.asm)     |    83K    | 1K   |  141µs   |       588M        |          8.2          |   D   |
| sieve  |    900    |  [mk13](nim/mk13.nim)   |    [src](asm/sieve_mk13.asm)     |    42K    | 1K   |   94µs   |       440M        |                       |   A   |
|        |           |                         |                                  |           |      |          |                   |                       |       |
| acker  |    3,7    |   [mk8](nim/mk8.nim)    | [src](asm/ackerman_mk8_mtkv.asm) |   12.8M   | 100  |  15.2ms  |       847M        |          5.7          |   A   |
| acker  |    3,7    |    [mk8c](c/mk8c.c)     | [src](asm/ackerman_mk8_mtkv.asm) |   12.8M   | 100  |  15.6ms  |       842M        |          5.7          |   B   |
| acker  |    3,7    |    [mk8c](c/mk8c.c)     | [src](asm/ackerman_mk8_mtkv.asm) |   12.8M   | 100  |   49ms   |       261M        |          18           |   C   |
| acker  |    3,7    |    [mk8c](c/mk8c.c)     | [src](asm/ackerman_mk8_mtkv.asm) |   12.8M   | 100  |   20ms   |       640M        |          7.5          |   D   |
| acker  |    3,7    |   [mk8ci](c/mk8ci.c)    | [src](asm/ackerman_mk8_mtkv.asm) |   12.8M   | 100  |  9.9ms   |       1292M       |          3.7          |   B   |
| acker  |    3,7    |   [mk8ci](c/mk8ci.c)    | [src](asm/ackerman_mk8_mtkv.asm) |   12.8M   | 100  |  9.8ms   |       1306M       |          3.7          |   D   |
| acker  |    3,7    |   [mk8cd](c/mk8cd.c)    | [src](asm/ackerman_mk8_mtkv.asm) |   12.8M   | 100  |  9.24ms  |       1385M       |          3.5          |   B   |
|        |           |                         |                                  |           |      |          |                   |                       |       |
| bsort  | 640 items |   [mk8](nim/mk8.nim)    |     [src](asm/bsort_mk8.asm)     |    3M     | 1000 |  3.69ms  |       830M        |          5.8          |   A   |
| bsort  | 640 items |    [mk8c](c/mk8c.c)     |     [src](asm/bsort_mk8.asm)     |    3M     | 1000 |  3.61ms  |       849M        |          5.6          |   B   |
| bsort  | 640 items |   [mk8ci](c/mk8ci.c)    |     [src](asm/bsort_mk8.asm)     |    3M     | 1000 |  2.5ms   |       1227M       |          3.9          |   B   |
| bsort  | 640 items |   [mk8cd](c/mk8cd.c)    |     [src](asm/bsort_mk8.asm)     |    3M     | 1000 |  2.48ms  |       1237M       |          3.9          |   B   |
|        |           |                         |                                  |           |      |          |                   |                       |       |
| qsort  | 640 items |   [mk8](nim/mk8.nim)    |     [src](asm/qsort_mk8.asm)     |   119K    | 1000 |  310µs   |       383M        |         12.6          |   A   |
| qsort  | 640 items |    [mk8c](c/mk8c.c)     |     [src](asm/qsort_mk8.asm)     |   119K    | 1000 |  227µs   |       524M        |          9.2          |   B   |
| qsort  | 640 items |   [mk8ci](c/mk8ci.c)    |     [src](asm/qsort_mk8.asm)     |   119K    | 1000 |  173µs   |       688M        |           7           |   B   |
| qsort  | 640 items |   [mk8cd](c/mk8cd.c)    |     [src](asm/qsort_mk8.asm)     |   119K    | 1000 |  181µs   |       658M        |          7.3          |   B   |
| qsort  | 640 items | [mk8](nim/mk8.nim) ext  |   [src](asm/qsort_mk8_ext.asm)   |    99K    | 1000 |  287µs   |       342M        |          14           |   A   |
| qsort  | 640 items | [mk8](nim/mk8.nim) ext2 |  [src](asm/qsort_mk8_ext2.asm)   |    91K    | 1000 |  277µs   |       327M        |         14.7          |   A   |
|        |           |                         |                                  |           |      |          |                   |                       |       |
| isort  | 640 items | [mk8](nim/mk8.nim) ext  |   [src](asm/isort_mk8_ext.asm)   |   669K    | 1000 |  900µs   |       742M        |          6.5          |   A   |
| isort  | 640 items |  [mk8c](c/mk8c.c) ext   |   [src](asm/isort_mk8_ext.asm)   |   669K    | 1000 |  813µs   |       822M        |          5.9          |   B   |
| isort  | 640 items |  [mk10](nim/mk10.nim)   |    [src](asm/isort_mk10.asm)     |   764K    | 1000 |  1.18ms  |       644M        |          7.5          |   A   |
|        |           |                         |                                  |           |      |          |                   |                       |       |
| ssort  | 640 items | [mk8](nim/mk8.nim) ext  |     [src](asm/ssort_mk8.asm)     |   4.2M    | 1000 |  4.82ms  |       858M        |          5.6          |   A   |
| ssort  | 640 items |  [mk8c](c/mk8c.c) ext   |   [src](asm/isort_mk8_ext.asm)   |   4.2M    | 1000 |  4.69ms  |       883M        |          5.5          |   B   |
| ssort  | 640 items | [mk8](nim/mk8.nim) ext  |  [src v2](asm/ssort_v2_mk8.asm)  |   2.5M    | 1000 |  3.0ms   |       830M        |          5.8          |   A   |
| ssort  | 640 items |  [mk8c](c/mk8c.c) ext   |  [src v2](asm/ssort_v2_mk8.asm)  |   2.5M    | 1000 |  2.86ms  |       872M        |          5.5          |   B   |
|        |           |                         |                                  |           |      |          |                   |                       |       |
| gsort  | 640 items | [mk8](nim/mk8.nim) ext  |     [src](asm/gsort_mk8.asm)     |           | 1000 |          |                   |                       |       |

**setup A**: i7-9700K @ 4.8GHz, gcc 11.4.0, **nim 2.0.0**, -d:cc -d:release -d:danger --gc:arc

**setup B**: i7-9700K @ 4.8GHz, **gcc 11.4.0**, -O3

**setup C**: i7-9700K @ 4.8GHz, **tcc 0.9.27**

**setup D**: i7-9700K @ 4.8GHz, **zig 0.11.0**, cc -O3
