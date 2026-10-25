# vimes2 - build and test
#
#   make test       build everything available and run all tests
#   make test-c     only C backends
#   make test-nim   only Nim backends (needs nim + ../nim-bench)
#   make test-js    only JS backends (hook for the browser implementation)
#   make test-asm   assembler unit tests (python/test_asm.py)
#   make expected   regenerate tests/expected/ from tests/oracle.py
#   make docs       regenerate docs/rosetta.md and docs/mk8.md

CC        ?= gcc
CFLAGS    ?= -O2
NIM       ?= nim
NIM_BENCH ?= ../nim-bench
NIMFLAGS  ?= --hints:off --warnings:off -d:cc -d:release -d:danger --mm:arc
PYTHON    ?= python3

C_VMS   = mk7c mk7ci mk7cd mk8c mk8ci mk8cd
NIM_VMS = mk6 mk7 mk8 mk9 mk10 mk11 mk12 mk13

.PHONY: all bin c-bin nim-bin test test-vm test-c test-nim test-js test-asm expected docs clean

all: bin

bin: c-bin nim-bin

c-bin: $(addprefix bin/,$(C_VMS))

bin/%: c/%.c c/cli.h $(wildcard c/*.h)
	@mkdir -p bin
	$(CC) $(CFLAGS) $< -o $@

nim-bin:
	@if command -v $(NIM) >/dev/null 2>&1 && [ -f $(NIM_BENCH)/bench.nim ]; then \
		mkdir -p bin; \
		for m in $(NIM_VMS); do \
			if [ ! -x bin/$${m}_nim ] || [ -n "$$(find nim -newer bin/$${m}_nim -name '*.nim')" ]; then \
				echo "$(NIM) c nim/$$m.nim -> bin/$${m}_nim"; \
				$(NIM) c $(NIMFLAGS) --path:$(abspath $(NIM_BENCH)) -o:$(abspath bin)/$${m}_nim nim/$$m.nim || exit 1; \
			fi; \
		done; \
	else \
		echo "nim or $(NIM_BENCH)/bench.nim not found - Nim backends will be skipped"; \
	fi

test: bin test-asm test-vm

test-vm:
	$(PYTHON) tools/run_tests.py

test-c: c-bin
	$(PYTHON) tools/run_tests.py --backend c

test-nim: nim-bin
	$(PYTHON) tools/run_tests.py --backend nim

test-js:
	$(PYTHON) tools/run_tests.py --backend js

test-asm:
	$(PYTHON) tools/test_asm_runner.py

expected:
	$(PYTHON) tools/run_tests.py --write-expected

docs: bin
	$(PYTHON) tools/run_tests.py > /dev/null || true
	$(PYTHON) tools/gen_docs.py

clean:
	rm -rf build $(addprefix bin/,$(C_VMS)) $(addprefix bin/,$(addsuffix _nim,$(NIM_VMS)))
