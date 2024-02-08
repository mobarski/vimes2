// !!! This file should be included after your vm.h !!!
// It requires the following definitions:
//   - Word
//   - mem
//   - mem_size
//   - stack
//   - stack_size
//   - code
//   - code_size
//   - cc
//   - reset()
//   - run()

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

typedef struct cli_config {
    char* filename;
    int   benchmark;
    int   mem_size;
    int   stack_size;
    int   code_size;
    bool  trace;
    bool  debug;
} cli_config;

// ============================================================================

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

// ============================================================================

void alloc_mem(cli_config cfg) {
    int n_words = cfg.mem_size + 4;
    mem_size = n_words;
    mem = (Word*)calloc(n_words, sizeof(Word));
    if (mem == NULL) {
        fprintf(stderr, "Error: could not allocate memory\n");
        exit(1);
    }
}

void alloc_code(cli_config cfg) {
    int n_words = cfg.code_size + 4;
    code_size = n_words;
    code = (Word*)calloc(n_words, sizeof(Word));
    if (code == NULL) {
        fprintf(stderr, "Error: could not allocate code\n");
        exit(1);
    }
}

void alloc_stack(cli_config cfg) {
    int n_words = cfg.stack_size + 4;
    stack_size = n_words;
    stack = (Word*)calloc(n_words, sizeof(Word));
    if (stack == NULL) {
        fprintf(stderr, "Error: could not allocate stack\n");
        exit(1);
    }
}

void load_code(cli_config cfg) {
    int n_words = code_from_num(cfg.filename, code, cfg.code_size);
    if (n_words < 0) {
        fprintf(stderr, "Error: could not load code\n");
        exit(1);
    }
}

void reset_mem() {
    for (int j = 0; j < mem_size; j++) {
        mem[j] = 0;
    }
}

void reset_stack() {
    for (int j = 0; j < stack_size; j++) {
        stack[j] = 0;
    }
}

void debug_mem() {
    // TODO
}

// ============================================================================

int timed_run(int n_times) {
    int64_t cycles = 0;
    clock_t start, end;
    double cpu_time_used = 0.0;

    for (int i = 0; i < n_times; i++) {
        reset(0);
        start = clock();
        run();
        end = clock();
        cpu_time_used += ((double) (end - start)) / CLOCKS_PER_SEC;
        cycles += cc;
    }

    fflush(stdout);
    fprintf(stderr, "\n");
    fprintf(stderr, "total time: %f seconds\n", cpu_time_used);
    fprintf(stderr, "total cycles: %ld\n", cycles);
    fprintf(stderr, "runs: %d\n", n_times);
    fprintf(stderr, "avg time: %f seconds\n", cpu_time_used/n_times);
    fprintf(stderr, "avg cycles: %ld\n", cycles/n_times);
    return 0;
}

void run_vm(cli_config cfg) {

    alloc_mem(cfg);
    alloc_code(cfg);
    alloc_stack(cfg);

    load_code(cfg);

    if (cfg.benchmark > 0) {
        timed_run(cfg.benchmark);
    } else {
        run();
    }
}

// ============================================================================

void print_usage(char *progname) {
    fprintf(stderr, "Usage: %s [options] <filename>\n", progname);
    fprintf(stderr, "Options:\n");
    fprintf(stderr, "  -b <n>  benchmark mode, n runs\n");
    fprintf(stderr, "  -m <n>  memory size (default 1000)\n");
    fprintf(stderr, "  -s <n>  stack size (default 100)\n");
    fprintf(stderr, "  -c <n>  code size (default 1000)\n");
    fprintf(stderr, "  --trace  enable trace mode\n");
    fprintf(stderr, "  --debug  enable debug mode\n");
    fprintf(stderr, "  --help   print this message\n");
}

// parse command line arguments
int cli_main(int argc, char *argv[]) {
    cli_config cfg = {};
    // default values
    cfg.mem_size = 1000;
    cfg.code_size = 1000;
    cfg.stack_size = 100;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--help")==0) {
            print_usage(argv[0]);
            return 0;
        } else if (strcmp(argv[i], "-b")==0) {
            cfg.benchmark = atoi(argv[i+1]);
            i++;
        } else if (strcmp(argv[i], "-m")==0) {
            cfg.mem_size = atoi(argv[i+1]);
            i++;
        } else if (strcmp(argv[i], "-s")==0) {
            cfg.stack_size = atoi(argv[i+1]);
            i++;
        } else if (strcmp(argv[i], "-c")==0) {
            cfg.code_size = atoi(argv[i+1]);
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
    run_vm(cfg);
    return 0;
}

