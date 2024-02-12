#include "mk8c.h"
#include "cli.h"

void reset(int quick) {
    pc = 0; cc = 0; acc = 0; sp = 0;
    if (!quick) reset_mem();   // from cli.h
    if (!quick) reset_stack(); // from cli.h
}

void trace(Word op, Word a) {
    char* opname = op<=20 ? opnames[op] : "???";
    fprintf(stderr, "| %4ld | %3d | %3d | %5s %3d | %3d | ", cc, pc, acc, opname, a, sp);
    fprintf(stderr, "\n");
}
 
void debug() {
    fprintf(stderr, "pc=%d sp=%d acc=%d\n", pc, sp, acc);
}

void run() {

    register Word pc = 0;     // program counter
    register Word acc = 0;    // accumulator
    register int64_t _cc = 0; // cycle counter
    Word tmp; // used in _IN, as acc is assigned to a register
    Word n;

    // cc++ in BEFORE is faster than cc++ in NEXT !!!
    #define BEFORE _cc++
    #define op     code[pc]
    #define a      code[pc+1]
    #define NEXT   goto *labels[op]

    void *labels[] = {
        &&_HLT, &&_IN,  &&_OUT, &&_LDA, &&_STA,
        &&_ADD, &&_SUB, &&_INC, &&_DEC, &&_JMP,
        &&_JZ,  &&_JN,  &&_LIT, &&_CAL, &&_RET,
        &&_LPA, &&_SPA, &&_ASR, &&_NOP, &&_PUSH,
        &&_POP,
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
    _IN:  BEFORE; n=fscanf(stdin, "%hd", &tmp);
                  /* TODO: handle n==0 */
                  acc=tmp;                    pc+=2; NEXT;
    _HLT: BEFORE;                             goto   END;
    // MK8
    _CAL: BEFORE; stack[sp]=pc; sp+=1;        pc=a;  NEXT;
    _RET: BEFORE; sp-=1; pc=stack[sp];        pc+=2; NEXT;
    _LPA: BEFORE; acc = mem[mem[a]];          pc+=2; NEXT;
    _SPA: BEFORE; mem[mem[a]] = acc;          pc+=2; NEXT;
    _ASR: BEFORE; acc >>= a;                  pc+=2; NEXT;
    _NOP: BEFORE;                             pc+=2; NEXT;
    // EXTENSION
    _PUSH: BEFORE; mem[a]+=1; mem[mem[a]]=acc; pc+=2; NEXT;
    _POP:  BEFORE; acc=mem[mem[a]]; mem[a]-=1; pc+=2; NEXT;
    END:
    cc = _cc;
}

int main(int argc, char *argv[]) {
    return cli_main(argc, argv);
}
