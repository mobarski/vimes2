# MK7 conditionals

|     condition | code                                           |
| ------------: | ---------------------------------------------- |
| **if a <= b** | `load b sub a jn end-if ... end-if:`           |
|  **if a < b** | `load b sub a jn end-if jz end-if ... end-if:` |
| **if a >= b** | `load a sub b jn end-if ... end-if:`           |
|  **if a > b** | `load a sub b jn end-if jz end-if ... end-if:` |



# MK13

- IDEA: stdio reads and writes from acc
- IDEA: acc used for offset in array access
  - poke a b ; mem[a+acc] = b
  - peek a b; a = mem[b+acc]
