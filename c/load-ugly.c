#include <stdio.h>
#include <stdint.h>

typedef int16_t Cell;

// load machine code from text file (space separated list of integers)
// into an array of Cells; returns number of cells loaded or negative value on error 
int code_from_num(char *filename, Cell *code, Cell max_code_size) {
    if (max_code_size < 1) {
        fprintf(stderr, "Error: max_code_size must be at least 1\n");
        return -1;
    }
    FILE *fp = fopen(filename, "r");
    if (fp == NULL) {
        fprintf(stderr, "Error: could not open file %s\n", filename);
        return -1;
    }
    Cell i = 0;
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
    const Cell max_code_size = 1000;
    Cell code[max_code_size];
    int n_cells = code_from_num("code.txt", code, max_code_size);
    for (int i = 0; i < n_cells; i++) {
        printf("%d ", code[i]);
    }
    printf("\n");
    return 0;   
}
