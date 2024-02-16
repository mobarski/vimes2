#include "mk8c.h"
#include "cli.h"

void reset(int quick) {
    pc = 0; cc = 0; acc = 0; sp = 0;
    if (!quick) reset_mem();   // from cli.h
    if (!quick) reset_stack(); // from cli.h
}

void trace(Word op, Word a) {
    Word watch[10] = {5,6,11,12,13};

    char* opname = op<=20 ? opnames[op] : "???";
    fprintf(stderr, "| %4ld | %3d | %3d | %5s %3d | %3d | ", cc, pc, acc, opname, a, sp);
    for (int i=0; i<10; i++) {
        if ((watch[i]>0) && (watch[i] < mem_size)) {
            fprintf(stderr, "%3d | ", mem[watch[i]]);
        }
    }
    fprintf(stderr, "\n");
}
 
void debug() {
    fprintf(stderr, "pc=%d sp=%d acc=%d\n", pc, sp, acc);
}

void run() {
    while (1) {
        Word tmp;
        Word opc = code[pc];
        Word op = (Word)opc;
        Word a = code[pc + 1];

        //trace(op, a); // TODO: only when cfg.trace and compiled with trace

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
            // MK8
            case CAL: stack[sp]=pc; sp+=1; pc=a; break;
            case RET: sp-=1; pc=stack[sp];       break;
            case LPA: acc = mem[mem[a]];     break;
            case SPA: mem[mem[a]] = acc;     break;
            case ASR: acc >>= a;             break;
            case NOP:                        break;
            // EXTENSION
            case PUSH: mem[a]+=1; mem[mem[a]]=acc; break;
            case POP:  acc=mem[mem[a]]; mem[a]-=1; break;
            // other
            case HLT: return;
            default:  return;
        }
    }
}

int main(int argc, char *argv[]) {
    return cli_main(argc, argv);
}
