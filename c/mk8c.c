#include "mk8c.h"
#include "cli.h"

void reset(int quick) {
    pc = 0; cc = 0; acc = 0;
    if (!quick) reset_mem();   // from cli.h
    if (!quick) reset_stack(); // from cli.h
}

// TODO trace
// TODO debug

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
            // MK8
            case CAL: stack[sp]=pc; sp+=1;   break;
            case RET: sp-=1; pc=stack[sp];   break;
            case LPA: acc = mem[mem[a]];     break;
            case SPA: mem[mem[a]] = acc;     break;
            case ASR: acc >>= a;             break;
            case NOP:                        break;
            // other
            case HLT: return;
            default:  return;
        }
    }
}

int main(int argc, char *argv[]) {
    return cli_main(argc, argv);
}
