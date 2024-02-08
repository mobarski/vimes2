#include "mk7c.h"
#include "cli.h"

void reset(int quick) {
    pc = 0; cc = 0; acc = 0;
    if (!quick) reset_mem();   // from cli.h
    if (!quick) reset_stack(); // from cli.h
}

// Assuming trace function is similar to Nim
void trace(Word op, Word a) {
    // This is a simplification; the original Nim code uses string formatting
    fprintf(stderr, "| %3ld | %2d | %2d %2d | %3d | \n", cc, pc, op, a, mem[a]);
}

void debug() {
    printf("pc: %d acc: %d cc: %ld\n", pc, acc, cc);
}

void run() {
    while (1) {
        Word tmp;
        Word opc = code[pc];
        Word op = (Word)opc;
        Word a = code[pc + 1];

        //trace(op, a); // XXX

        cc += 1;
        pc += 2;
        switch (op) {
            // control flow
            case JZ:  if (acc == 0) pc = a;  break;
            case JN:  if (acc < 0)  pc = a;  break;
            case JMP: pc = a;                break;
            // data transfer
            case LDA: acc = mem[a];          break;
            case LIT: acc = a;               break;
            case STA: mem[a] = acc;          break;
            // alu
            case ADD: acc += mem[a];         break;
            case SUB: acc -= mem[a];         break;
            case INC: mem[a] += 1;           break;
            case DEC: mem[a] -= 1;           break;
            // stdio
            case OUT: printf("%d ", acc);    break;
            case IN:
                tmp = fscanf(stdin, "%hd", &acc);
                // TODO: tmp==0
                break;
            // other
            case HLT: return;
            default:  return;
        }
    }
}

int main(int argc, char *argv[]) {
    return cli_main(argc, argv);
}
