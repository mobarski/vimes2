# MK7 conditionals

|     condition | code                                           |
| ------------: | ---------------------------------------------- |
| **if a <= b** | `load b sub a jn end-if ... end-if:`           |
|  **if a < b** | `load b sub a jn end-if jz end-if ... end-if:` |
| **if a >= b** | `load a sub b jn end-if ... end-if:`           |
|  **if a > b** | `load a sub b jn end-if jz end-if ... end-if:` |
