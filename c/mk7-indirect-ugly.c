#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h> // Added for measuring execution time

typedef enum {
    IN = 1,
    OUT = 2,
    LDA = 3,
    STA = 4,
    ADD = 5,
    SUB = 6,
    INC = 7,
    DEC = 8,
    JMP = 9,
    JZ = 10,
    JN = 11,
    // EXTENSION
    LIT = 12
} Instr;

typedef int16_t Cell;

Cell mem[100]; // memory, fixed size for simplicity
Cell code[256] = {1,0,4,0,3,0,4,2,3,2,10,42,8,2,3,0,4,3,3,3,10,40,8,3,3,0,4,4,3,4,10,38,8,4,7,1,9,28,9,18,9,8,3,1,2,0,  0,0,0,0};

// void reset(int quick) {
//     pc = 0; acc = 0; cc = 0;
//     if (quick) return;
//     for (int j = 0; j < sizeof(mem) / sizeof(mem[0]); j++) {
//         mem[j] = 0;
//     }
// }


// // Assuming trace function is similar to Nim
// void trace(Cell op, Cell a) {
//     // This is a simplification; the original Nim code uses string formatting
//     fprintf(stderr, "| %3lld | %2d | %4s %2d | %3d | \n", cc, pc, "todo", a, mem[a]);
// }

void debug() {
    //printf("pc: %d op: %d acc: %d cc: %lld\n", pc, code[pc], acc, cc);
}

void run() {

    register Cell pc = 0; // program counter
    register int64_t cc = 0; // used only when -d:cc is passed
    Cell acc = 0; // accumulator

    #define BEFORE
    #define op     code[pc]
    #define a      code[pc+1]
    #define NEXT   cc++; goto *labels[op]

    void *labels[] = {
        &&_HLT, &&_IN, &&_OUT, &&_LDA, &&_STA, &&_ADD, &&_SUB, &&_INC, &&_DEC, &&_JMP, &&_JZ, &&_JN, &&_LIT
    };

    NEXT;
    _JZ:  BEFORE; pc = (acc==0)? a :          pc+2;  NEXT;
    _JN:  BEFORE; pc = (acc<0) ? a :          pc+2;  NEXT;
    _JMP: BEFORE;                             pc=a;  NEXT;
    _LDA: BEFORE; acc=mem[a];                 pc+=2; NEXT;
    _LIT: BEFORE; acc=a;                      pc+=2; NEXT;
    _STA: BEFORE; mem[a]=acc;                 pc+=2; NEXT;
    _ADD: BEFORE; acc+=mem[a];                pc+=2; NEXT;
    _SUB: BEFORE; acc-=mem[a];                pc+=2; NEXT;
    _INC: BEFORE; mem[a]++;                   pc+=2; NEXT;
    _DEC: BEFORE; mem[a]--;                   pc+=2; NEXT;
    _OUT: BEFORE; printf("%d ", acc);         pc+=2; NEXT;
    _IN:  BEFORE; fscanf(stdin, "%hd", &acc); pc+=2; NEXT;
    _HLT: BEFORE;                             return;
}

int main() {
    // Initialize memory
    for (int i = 0; i < 100; i++) {
        mem[i] = 0;
    }

    clock_t start, end;
    double cpu_time_used;
    start = clock();
    run();
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("run() took %f seconds to execute \n", cpu_time_used);
    return 0;
}
