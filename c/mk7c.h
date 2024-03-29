#include <stdint.h>

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
    LIT = 12,
} Instr;

typedef int16_t Word;

Word pc = 0; // program counter
Word acc = 0; // accumulator
Word *mem; // memory
Word *code; // code
Word *stack; // stack (not used)
Word mem_size; // memory size
Word code_size; // code size
Word stack_size; // stack size
int64_t cc = 0; // cycle counter

void reset(int quick);
void run();

