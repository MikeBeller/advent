import numpy as np


def parse(instr):
    return np.vstack([
        np.frombuffer(bytes(s, encoding='utf8'), dtype=np.int8) - 48
        for s in instr.splitlines()])


tds = """
2199943210
3987894921
9856789892
8767896789
9899965678
""".strip()

td = parse(tds)
data = parse(open("input.txt").read())


def part1(data):
    down = np.diff(data, axis=0, append=np.nan)
    right = np.diff(data, axis=1, append=np.nan)
    up = -np.roll(down, shift=1, axis=0)
    left = -np.roll(right, shift=1, axis=1)
    diffs = np.stack([down, right, up, left], axis=0)
    print(diffs)
    mn = np.all(np.isnan(diffs) | (diffs > 0), axis=0)
    return np.sum(data[mn] + 1)


assert part1(td) == 15
#print("PART1:", part1(data))
