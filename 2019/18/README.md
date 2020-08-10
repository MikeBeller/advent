# Speed Comparisons for Advent 2019 Problem 18 Part 1

    Python    160s
    Pypy3      58s  # also the 201918pypy3.py -- same performance
    Go         15s
    Rust        6s

To optimize, the function taking all the time was key_distances
In go if you make the "visited" (vs) data structure an array
instead of a hash table, it makes a huge difference (60 seconds
goes down to 25 seconds), then if you pre-allocate the deque "q"
it reduces to 15 seconds.

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

