# Performance of 2020-23 "Crab Cups" In Different Implementations

Some implementations. (Timings are for full 1M cups, 10M
rounds.  Tests of smaller problems removed from timing runs.)

* Using a linked list, and an associated dictionary, in python
* Using a single hash table, in python and julia
* Using a single array, in python and julia, and C
* Tried a single array with different 'arrays': ndarray, array.array

 Solution               |  Time
 -----------------------|:-------:
 Elixir, Map            |  52.9s
 Elixir, Array          |  32.4s
 Ndarray, python        |  18.1s     # accessing ndarray from python is slow
 Linked list, python    |  17.8s
 Linked list, pypy      |   4.7s
 List, python           |   5.6s
 Array.array, python    |   5.1s     # must use 'I' (uint32) for best timing
 Hashtable, python      |   7.6s
 List, pypy             |   0.37s
 Array.array, pypy      |   0.23s
 Hashtable, pypy        |   3.0s
 Ndarray, pypy          | 108.0s     # ndarray from pypy3 is insanely slow
 Janet array            |   2.6s     # twice as fast as python!
 Janet table            |   4.6s
 Julia int32 array      |   0.21s
 Julia int64 array      |   0.35s
 Julia hashtable        |   6.8s
 C int32 array          |   0.21s
 C int64 array          |   0.36s
 WASM wasmer jit        |   0.30
 WASM wasmtime cranelift|   0.35
 WASM node.js           |   0.37
 Assemblyscript -O3     |   0.24
 Javascript Int32Array  |   0.26     # similar to pypy array.array solution
 Rust                   |   0.21     # as fast as C
 Lua w/array attribs    |   1.41
 Lua w pure array       |   1.32     # 4 times faster than python!!
 Luajit (attrib or no)  |   0.48     # not much speedup over pure array lua
 Zig ReleaseFast        |   0.21     # same as Rust and C int32

# Versions:

* Python-3.8.3 anaconda
* Pypy-7.3.0 (python 3.6.9)
* Julia 1.5.3
* gcc 7.5 -O3
* Janet 1.13
* wat2wasm 1.0.13, wasmer 1.0.0-rc1 or wasmtime 0.20.0 or node.js 12.18.1
* jscript is just node 12.18.1
* Rust 1.47.0
* Zig 0.8.0-dev.1127+6a5a6386c

# OBSERVATIONS

* Python hashtable version is 40% slower than array version
* Pypy array is 20x faster than python version (but pypy hashtable is only 2x!)
* Array.array is slightly faster than python lists in pypy and python
* Julia and pypy are roughtly equivalent, and both equivalent to C
  **not including warmup**
* Accessing ndarray's from python is very slow and insanely slow from pypy!
* Janet actually performs better than regular python on this benchmark
* WASM is almost competitive with C/Julia_int32  (takes 1.5x as long, like pypy "list" version)

