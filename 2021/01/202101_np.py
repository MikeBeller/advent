import numpy as np

td = np.array([ 199, 200, 208, 210, 200, 207, 240, 269, 260, 263 ])
data = np.loadtxt("input.txt", dtype=np.int32)

def part1(a):
    return np.count_nonzero(np.diff(a) > 0)
assert part1(td) == 7
print("PART1:", part1(data))

def part2(a):
    return part1(np.convolve(a, np.ones(3,dtype=np.int32), 'valid'))
assert part2(td) == 5
print("PART2:", part2(data))
