#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h> // Added for measuring execution time

typedef enum {
	HLT = 0,
    IN  = 1,
    OUT = 2,
    LDA = 3,
    STA = 4,
    ADD = 5,
    SUB = 6,
    INC = 7,
    DEC = 8,
    JMP = 9,
    JZ  = 10,
    JN  = 11,
    // EXTENSION
    LIT = 12
} Instr;

typedef int16_t Cell;

Cell pc = 0; // program counter
Cell acc = 0; // accumulator
int64_t cc = 0; // used only when -d:cc is passed
Cell mem[100]; // memory, fixed size for simplicity
Cell code[256] = {1,0,4,0,3,0,4,2,3,2,10,42,8,2,3,0,4,3,3,3,10,40,8,3,3,0,4,4,3,4,10,38,8,4,7,1,9,28,9,18,9,8,3,1,2,0,  0,0,0,0};

void reset(int quick) {
    pc = 0; acc = 0; cc = 0;
    if (quick) return;
    for (int j = 0; j < sizeof(mem) / sizeof(mem[0]); j++) {
        mem[j] = 0;
    }
}

// Assuming trace function is similar to Nim
void trace(Cell op, Cell a) {
    // This is a simplification; the original Nim code uses string formatting
    fprintf(stderr, "| %3ld | %2d | %4s %2d | %3d | \n", cc, pc, "todo", a, mem[a]);
}

void debug() {
    printf("pc: %d acc: %d cc: %ld\n", pc, acc, cc);
}

void run() {
    while (1) {
        Cell op = (Cell)code[pc++];
        Cell a = code[pc++];
        //cc++;
        switch (op) {
            // control flow
            case JZ: if (acc == 0) pc = a; break;
            case JN: if (acc < 0) pc = a;  break;
            case JMP: pc = a;              break;
            case LDA: acc = mem[a];        break;
            case LIT: acc = a;             break;
            case STA: mem[a] = acc;        break;
            case ADD: acc += mem[a];       break;
            case SUB: acc -= mem[a];       break;
            case INC: mem[a] += 1;         break;
            case DEC: mem[a] -= 1;         break;
            case OUT: printf("%d ", acc);         break;
            case IN:  fscanf(stdin, "%hd", &acc); break;
            case HLT: return;
            default:  return;
        }
        // replication 1
        op = code[pc++]; // problematic with trace (pc+=2 will be better, but this should be faster)
        a = code[pc++];  // problematic with trace (pc+=2 will be better, but this should be faster)
        //cc++;
        switch (op) {
            // control flow
            case JZ: if (acc == 0) pc = a; break;
            case JN: if (acc < 0) pc = a;  break;
            case JMP: pc = a;              break;
            case LDA: acc = mem[a];        break;
            case LIT: acc = a;             break;
            case STA: mem[a] = acc;        break;
            case ADD: acc += mem[a];       break;
            case SUB: acc -= mem[a];       break;
            case INC: mem[a] += 1;         break;
            case DEC: mem[a] -= 1;         break;
            case OUT: printf("%d ", acc);         break;
            case IN:  fscanf(stdin, "%hd", &acc); break;
            case HLT: return;
            default:  return;
        }
        // replication 2
        op = code[pc++]; // problematic with trace (pc+=2 will be better, but this should be faster)
        a = code[pc++];  // problematic with trace (pc+=2 will be better, but this should be faster)
        //cc++;
        switch (op) {
            // control flow
            case JZ: if (acc == 0) pc = a; break;
            case JN: if (acc < 0) pc = a;  break;
            case JMP: pc = a;              break;
            case LDA: acc = mem[a];        break;
            case LIT: acc = a;             break;
            case STA: mem[a] = acc;        break;
            case ADD: acc += mem[a];       break;
            case SUB: acc -= mem[a];       break;
            case INC: mem[a] += 1;         break;
            case DEC: mem[a] -= 1;         break;
            case OUT: printf("%d ", acc);         break;
            case IN:  fscanf(stdin, "%hd", &acc); break;
            case HLT: return;
            default:  return;
        }
    }
}

int main() {
    clock_t start, end;
    double cpu_time_used;
    start = clock();
    // Initialize memory
    // for (int i = 0; i < 100; i++) {
    //     mem[i] = 0;
    // }

    for (int i = 0; i < 30; i++) {
        reset(1);
        run();
    }

    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("run() took %f seconds to execute \n", cpu_time_used);
    return 0;
}
