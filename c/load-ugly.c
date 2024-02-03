#include <stdio.h>
#include <stdint.h>

typedef int16_t Word;

// load machine code from text file (space separated list of integers)
// into an array of Words; returns number of words loaded or negative value on error 
int code_from_num(char *filename, Word *code, Word max_code_size) {
    if (max_code_size < 1) {
        fprintf(stderr, "Error: max_code_size must be at least 1\n");
        return -1;
    }
    FILE *fp = fopen(filename, "r");
    if (fp == NULL) {
        fprintf(stderr, "Error: could not open file %s\n", filename);
        return -1;
    }
    Word i = 0;
    while (fscanf(fp, "%hd", &code[i]) != EOF) {
        if (i >= max_code_size) {
            fprintf(stderr, "Error: code too large for code array\n");
            return -1;
        }
        i++;
    }
    fclose(fp);
    return i;
}

int main() {
    const Word max_code_size = 1000;
    Word code[max_code_size];
    int n_words = code_from_num("code.txt", code, max_code_size);
    for (int i = 0; i < n_words; i++) {
        printf("%d ", code[i]);
    }
    printf("\n");
    return 0;   
}
