#include "mk7cd.h"
#include "cli.h"

void reset(int quick) {
    if (!quick) reset_mem();   // from cli.h
    if (!quick) reset_stack(); // from cli.h
}

void run() {

    register Word pc = 0;     // program counter
    register Word acc = 0;    // accumulator
    register int64_t _cc = 0; // cycle counter
    Word tmp; // used in _IN, as acc is assigned to a register
    Word n;

    #define BEFORE
    #define a      code[pc+1]
    #define NEXT   _cc++; goto *code2[pc]
    // cc++ in NEXT is faster than cc++ in BEFORE !!!

    void *labels[] = {
        &&_HLT, &&_IN, &&_OUT, &&_LDA, &&_STA, &&_ADD, &&_SUB, &&_INC, &&_DEC, &&_JMP, &&_JZ, &&_JN, &&_LIT
    };
    for (int i=0; i<code_size; i+=2) {
        code2[i] = labels[code[i]];
    }

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
                  // TODO n==0
                  acc=tmp;                    pc+=2; NEXT;
    _HLT: BEFORE;                             goto   END;

    END:
    cc = _cc;
}

int main(int argc, char *argv[]) {
    return cli_main(argc, argv);
}
