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

#define jz(x)  cc++; if (acc==0) goto x
#define jn(x)  cc++; if (acc<0)  goto x
#define jmp(x) cc++; goto x
#define lda(x) cc++; acc=mem[x]
#define lit(x) cc++; acc=x
#define sta(x) cc++; mem[x]=acc
#define add(x) cc++; acc+=mem[x]
#define sub(x) cc++; acc-=mem[x]
#define inc(x) cc++; mem[x]+=1
#define dec(x) cc++; mem[x]-=1
#define out(x) cc++; put_int(acc)
#define in(x)  cc++; acc=get_int()
#define hlt(x) cc++; return cc

Word mem[100] = {};
int64_t run() {
    register Word   acc = 0; // accumulator
    register int64_t cc = 0; // used only when -d:cc is passed 

    in(0); sta(0);
    lda(0); sta(2);
    loop1:
        lda(2); jz(loop1_end);
        dec(2);
        lda(0); sta(3);
        loop2:
            lda(3); jz(loop2_end);
            dec(3);
            lda(0); sta(4);
            loop3:
                lda(4); jz(loop3_end);
                dec(4);
                inc(1);
                jmp(loop3);
            loop3_end:
            jmp(loop2);
        loop2_end:
        jmp(loop1);
    loop1_end:
    lda(1); out(0);
    hlt(0);

    return cc;
}

int main() {
    clock_t start, end;
    double cpu_time_used;
    int64_t cc = 0;
    start = clock();

    for (int i = 0; i < 30; i++) {
        cc += run();
    }

    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("run() took %f seconds to execute \n, cc=%ld", cpu_time_used, cc);
    return 0;
}
