#!/usr/bin/env python3
# runs python/test_asm.py without requiring pytest (uses pytest if installed)
import os, sys, traceback
ROOT = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'python'))
try:
    import pytest
    sys.exit(pytest.main(['-q', os.path.join(ROOT, 'python', 'test_asm.py')]))
except ImportError:
    pass
os.chdir(os.path.join(ROOT, 'python')) # tests use paths relative to python/
import test_asm
n_pass = n_fail = 0
for name, fn in sorted(vars(test_asm).items()):
    if name.startswith('test_') and callable(fn):
        try:
            fn(); n_pass += 1
        except Exception:
            n_fail += 1
            print(f'FAIL {name}'); traceback.print_exc()
print(f'asm tests passed: {n_pass}  failed: {n_fail}')
sys.exit(1 if n_fail else 0)
