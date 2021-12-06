from timeit import timeit
import numpy as np

td = np.array([3, 4, 3, 1, 2], dtype=np.int8)
data = np.loadtxt("input.txt", delimiter=",", dtype=np.int8)


# brute force simulation
def part1(data, ndays):
    a = data.copy()
    for d in range(ndays):
        n = (a == 0).sum()
        a[a == 0] = 7
        a -= 1
        a = np.concatenate([a, np.full(n, 8)])
    return a.size


# optimized simulation of same process
def part2(data, ndays):
    cs = np.bincount(data, minlength=9)
    for d in range(ndays):
        nn = cs[0]
        cs[7] += nn
        cs = np.roll(cs, -1)
    return cs.sum()


assert part1(td, 18) == 26
assert part1(td, 80) == 5934
print("PART1:", part1(data, 80))

assert part2(td, 18) == 26
assert part2(td, 80) == 5934
assert part2(td, 256) == 26984457539
print("PART2:", part2(data, 256))

print("TIME:", timeit("part2(data, 256)", number=3, globals=globals()))
