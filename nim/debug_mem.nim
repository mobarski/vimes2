
proc debug_mem(N=20, skip_empty=true) =
    stderr.write("\nMemory dump:\n")
    for i in countup(0, mem.len-1, N):
        var n_zeros = 0
        for j in 0..<N:
            if i+j >= mem.len: break
            if mem[i+j] == 0:
                n_zeros += 1
        if n_zeros == N and skip_empty:
            continue
        stderr.write("{i:04d} ".fmt)
        for j in 0..<N:
            if i+j >= mem.len: break
            if j mod 5 == 0: stderr.write("| ")
            stderr.write("{mem[i+j]} ".fmt)
        stderr.write("|\n")

