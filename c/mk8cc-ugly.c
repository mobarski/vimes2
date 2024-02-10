#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h> // Added for measuring execution time

typedef int16_t Word;

Word get_int() {
    int tmp;
    fscanf(stdin, "%hd", &tmp);
    return tmp;
}
void put_int(Word x) {
    printf("%d\n",x);
}

#define BEFORE cc++
#define jz(x)  BEFORE; if (acc==0) goto x
#define jn(x)  BEFORE; if (acc<0)  goto x
#define jmp(x) BEFORE; goto x
#define lda(x) BEFORE; acc=mem[x]
#define lit(x) BEFORE; acc=x
#define sta(x) BEFORE; mem[x]=acc
#define add(x) BEFORE; acc+=mem[x]
#define sub(x) BEFORE; acc-=mem[x]
#define inc(x) BEFORE; mem[x]+=1
#define dec(x) BEFORE; mem[x]-=1
#define out(x) BEFORE; put_int(acc)
#define in(x)  BEFORE; acc=get_int()
#define hlt(x) BEFORE; return cc
// MK8
#define cal(x,nxt) BEFORE; stack[sp]=&&nxt; sp+=1; goto x; nxt:
#define ret(x)     BEFORE; sp-=1; goto *stack[sp]
#define lpa(x)     BEFORE; acc=mem[mem[x]]
#define spa(x)     BEFORE; mem[mem[x]]=acc
#define asr(x)     BEFORE; acc>>=x
#define nop(x)     BEFORE;

Word mem[100] = {};
void* stack[100] = {};

int64_t run() {
    register Word   acc = 0; // accumulator
    register int64_t cc = 0; // used only when -d:cc is passed 
    register Word    sp = 0; // stack pointer

    in(0); sta(1);
    lit(42); out(0);
    cal(lucky,xxx);
    lit(42); out(0);
    hlt(0);
    lucky:
        lda(1); out(0); out(0); out(0);
        ret(0);

    return cc;
}

int main() {
    clock_t start, end;
    double cpu_time_used;
    int64_t cc = 0;
    start = clock();

    for (int i = 0; i < 1; i++) {
        cc += run();
    }

    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("run() took %f seconds to execute \n, cc=%ld", cpu_time_used, cc);
    return 0;
}
