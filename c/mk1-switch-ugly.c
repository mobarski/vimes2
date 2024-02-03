#include <stdio.h>
#include <assert.h>

typedef short int Word;
#define STACK_SIZE 1000

enum {
    LIT = 1, OPR, LOD, STO, CAL, INT, JMP, JPC
};

enum {
    RET = 0, NEG, ADD, SUB, MUL, DIV, ODD, MOD, EQ, NE, LT, LE, GT, GE
};

Word p = 0; // program counter
Word b = 0; // base pointer
Word t = 0; // top of stack pointer
Word s[STACK_SIZE]; // stack

Word base(Word level) {
    Word b1 = b;
    while (level > 0) {
        b1 = s[b1];
        level--;
    }
    return b1;
}

void run(const int *code) {
    while (1) {
        Word i = (Word)code[p];
        Word l = (Word)code[p + 1];
        Word a = (Word)code[p + 2];
        p += 3;

        switch (i) {
            case LIT: t++; s[t] = a; break;
            case LOD: t++; s[t] = s[base(l) + a]; break;
            case STO: s[base(l) + a] = s[t]; t--; break;
            case INT: t += a; break;
            case JMP: p = a; break;
            case JPC: if (s[t] == 0) { p = a; } t--; break;
            case CAL:
                s[t + 1] = base(l);
                s[t + 2] = b;
                s[t + 3] = p;
                b = t + 1;
                p = a;
                break;
            case OPR:
                switch (a) {
                    case RET: t = b - 1; p = s[t + 3]; b = s[t + 2]; break;
                    case NEG: s[t] = -s[t]; break;
                    case ADD: t--; s[t] += s[t + 1]; break;
                    case SUB: t--; s[t] -= s[t + 1]; break;
                    case MUL: t--; s[t] *= s[t + 1]; break;
                    case DIV: t--; s[t] /= s[t + 1]; break;
                    case ODD: s[t] %= 2; break;
                    case MOD: t--; s[t] %= s[t + 1]; break;
                    case EQ:  t--; s[t] = (s[t] == s[t + 1]) ? 1 : 0; break;
                    case NE:  t--; s[t] = (s[t] != s[t + 1]) ? 1 : 0; break;
                    case LT:  t--; s[t] = (s[t] <  s[t + 1]) ? 1 : 0; break;
                    case LE:  t--; s[t] = (s[t] <= s[t + 1]) ? 1 : 0; break;
                    case GT:  t--; s[t] = (s[t] >  s[t + 1]) ? 1 : 0; break;
                    case GE:  t--; s[t] = (s[t] >= s[t + 1]) ? 1 : 0; break;
                    default: assert(0); break;
                }
                break;
            default: assert(0); break;
        }

        if (p == 0) {
            break;
        }
    }
}

void reset(int quick) {
    p = 0; b = 0; t = 0;
    if (!quick) {
        for (int j = 0; j < STACK_SIZE; j++) {
            s[j] = 0;
        }
    }
}

void debug() {
    printf("p:%d b:%d t:%d s:", p, b, t);
    for (int i = 1; i <= t; i++) {
        printf("%d ", s[i]);
    }
    printf("\n");
}

int main() {
    int vm_code[] = {
        INT, 0, 0, // nop
        LIT, 0, 11,
        LIT, 0, 22,
        OPR, 0, ADD,
        OPR, 0, NEG,
        LIT, 0, -9,
        OPR, 0, ADD,
        JMP, 0, 0, // halt
    };

    run(vm_code);
    debug();
    reset(0);
    debug();

    return 0;
}
