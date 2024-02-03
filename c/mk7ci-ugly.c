#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h> // Added for measuring execution time

typedef int16_t Word;

Word mem[100]; // memory, fixed size for simplicity
Word code[256] = {1,0,4,0,3,0,4,2,3,2,10,42,8,2,3,0,4,3,3,3,10,40,8,3,3,0,4,4,3,4,10,38,8,4,7,1,9,28,9,18,9,8,3,1,2,0,  0,0,0,0};

void debug() {
    // TODO
}

int64_t run() {

    register Word pc = 0; // program counter
    register int64_t cc = 0; // used only when -d:cc is passed
    Word acc = 0; // accumulator


    #define BEFORE cc++
    #define op     code[pc]
    #define a      code[pc+1]
    #define NEXT   goto *labels[op]

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
    _HLT: BEFORE;                             goto END;

    END:
    return cc;
}

int main() {
    clock_t start, end;
    double cpu_time_used;
    int64_t cc = 0;
    start = clock();
    // Initialize memory
    // for (int i = 0; i < 100; i++) {
    //     mem[i] = 0;
    // }

    for (int i = 0; i < 30; i++) {
        cc += run();
    }

    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("run() took %f seconds to execute \n, cc=%ld", cpu_time_used, cc);
    return 0;
}
