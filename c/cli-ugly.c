#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

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

typedef struct cli_config {
    char* filename;
    int   benchmark; // TODO: parse -b:n
    bool  trace; // TODO: parse --trace
    bool  debug; // TODO: parse --debug
    // TODO: mem size
    // TODO: code size
    // TODO: stack size
} cli_config;

int cli(cli_config cfg) {
    const Word max_code_size = 1000;
    Word code[max_code_size];
    int n_words = code_from_num(cfg.filename, code, max_code_size);
    if (n_words < 0) {
        return -1;
    }

    for (int i = 0; i < n_words; i++) {
        printf("%d ", code[i]);
    }
    printf("\n");
}

void print_usage(char *progname) {
    fprintf(stderr, "Usage: %s [options] <filename>\n", progname);
}

// parse command line arguments
int main(int argc, char *argv[]) {
    cli_config cfg = {};
    for (int i = 1; i < argc; i++) {
        //fprintf(stderr, "arg%d: %s\n", i, argv[i]);
        if (strcmp(argv[i], "-b")==0) {
            cfg.benchmark = atoi(argv[i+1]);
            i++;
        } else if (strcmp(argv[i], "--trace")==0) {
            cfg.trace = true;
        } else if (strcmp(argv[i], "--debug")==0) {
            cfg.debug = true;
        } else {
            cfg.filename = argv[i];
        }
    }
    if (cfg.filename == NULL) {
        print_usage(argv[0]);
        return -1;
    }
    cli(cfg);
    return 0;
}
