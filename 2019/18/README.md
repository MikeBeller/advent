# Speed Comparisons for Advent 2019 Problem 18 Part 1

    Python    160s
    Pypy3      58s
    Go         15s
    Rust        6s

To optimize, the function taking all the time was key_distances
In go if you make the "visited" (vs) data structure an array
instead of a hash table, it makes a huge difference (60 seconds
goes down to 25 seconds), then if you pre-allocate the deque "q"
it reduces to 15 seconds.


