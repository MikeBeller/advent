import numpy as np
import os
dir_path = os.path.dirname(os.path.realpath(__file__))

td = np.array([16, 1, 2, 0, 4, 2, 7, 1, 2, 14])
data = np.loadtxt(f"{dir_path}/input.txt", delimiter=",", dtype=np.int64)


def part1(cs):
    d = np.percentile(cs, 50, interpolation='nearest')
    return np.sum(np.abs(cs - d))


assert (part1(td)) == 37
print("PART1:", part1(data))


def cost(cs, d):
    dif = np.abs(cs - d)
    return np.sum(dif * (dif + 1) // 2)


def part2(cs):
    return np.min(
        [cost(cs, d) for d in range(len(cs))]
    )


assert part2(td) == 168
print("PART2:", part2(data))
