#Advent of Code 2020 day 13 in micropython
# runs in 216ms on SAMD21g18 (48MHz clock, 32k of RAM)

import time

def read_data(inp):
    sts,rests = inp.split("\n", 1)
    st = int(sts)
    rest = [int(s if s != "x" else "-1") for s in rests.split(",")]
    return st,rest

def part1(data):
    (dtm, all_buses) = data
    buses = [b for b in all_buses if b != -1]
    (bid, delay) = min([(b - (dtm % b), b) for b in buses])
    return bid * delay

def norm(x,b):
    v = x % b
    return v if v >= 0 else v + b

def part2(data):
    (dtm, all_buses) = data
    poly = [(b, norm(-i,b)) for (i,b) in enumerate(all_buses) if b != -1]
    (m,r) = poly[0]
    for (b,i) in poly[1:]:
        while r % b != i:
            r += m
        m *= b
    return r

def main():
    td = read_data("939\n7,13,x,x,59,x,31,19")
    assert part1(td) == 295
    data = read_data(open("input.txt").read())
    print("PART1:", part1(data))

    assert part2(td) == 1068781
    print("PART2:", part2(data))


import gc
st_mem = gc.mem_free() if 'mem_free' in dir(gc) else 0
st_tm = time.monotonic()
main()
end_tm = time.monotonic()
#gc.collect()
end_mem = gc.mem_free() if 'mem_free' in dir(gc) else 0
print("MEM:", end_mem, "USED:",  st_mem-end_mem, "TIME(ms):", (end_tm - st_tm))

