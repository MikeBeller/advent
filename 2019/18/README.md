# Speed Comparisons for Advent 2019 Problem 18 Part 1

On Hal, anaconda python 3.8:

    Python     201918.py            92s
    Pypy3      201918pypy3.py       29s
    Pypy3      201918.py            24s
    Numba      201918numba.py       18s (cached or ignoring tests)
    Numba      201918numba_bits.py  13s (cached or ignoring tests)
    Go         alt18.go             9.3 real 13.7 user
    Julia      alt18.jl             8.7s (7.8s without tests)
    Rust       alt18rs.rs           5s (rustc -O o alt18rs alt18rs.rs)

To optimize, the function taking all the time was key_distances
In go if you make the "visited" (vs) data structure an array
instead of a hash table, it makes a huge difference (60 seconds
goes down to 25 seconds), then if you pre-allocate the deque "q"
it reduces to 15 seconds.

On aws m5.large with stock anaconda python 3.8:

    Python      120s   Anaconda python 3.8
    Numba        22s   Anaconda python 3.8 numba 0.50
    Numba/cache  15s   Numba 0.50 but cache the compilation
    Numba/nocomp 15s   Numba 0.50 but don't measure comp time
    Go           11s/15.5s user   Go 1.15
    Julia        10s   Julia 1.5.0 (plus 1 s compile & test time)

## To optimize pypy3

Note that arrays of different types have very different speeds
in pypy3.  For summing the items in a 1000x1000 array 30 times,
the speeds are:

                  pypy3         cpython3.8
    numpy         2887ms!!        428ms
    listoflists   2.7ms           87ms
    1-d list      2.1ms           76ms
    array.array   2.1ms           92ms

Basically interworking between numpy and cpython is slow,
and between pypy and numpy is a disaster!

## To optimize for numba

Needed to simplify State class so that it only had types
supported by numba.  Specifically instead of frozenset
for keys, we now use numpy arrays.  

