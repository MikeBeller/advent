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

R, D, L, U = [0, 1, 2, 3]


def get_diffs(data):
    right = np.diff(data, axis=1, append=np.nan)
    down = np.diff(data, axis=0, append=np.nan)
    left = -np.roll(right, shift=1, axis=1)
    up = -np.roll(down, shift=1, axis=0)
    diffs = np.stack([right, down, left, up], axis=0)
    return diffs


def part1(data):
    diffs = get_diffs(data)
    mn = np.all(np.isnan(diffs) | (diffs > 0), axis=0)
    return np.sum(data[mn] + 1)


assert part1(td) == 15
print("PART1:", part1(data))


def move(dr, y, x):
    if dr == R:
        return y, x+1
    elif dr == D:
        return y+1, x
    elif dr == L:
        return y, x-1
    elif dr == U:
        return y-1, x


def part2(data):
    diffs = get_diffs(data)
    mn = np.all(np.isnan(diffs) | (diffs > 0), axis=0)
    ys, xs = np.where(mn)
    start_pts = list(zip(ys, xs))
    size = [0] * len(start_pts)
    for i, (ystart, xstart) in enumerate(start_pts):
        pts = [(ystart, xstart)]
        visited = set(pts)
        while True:
            nv = set()
            for y, x in pts:
                for dr in [R, D, L, U]:
                    if diffs[dr, y, x] > 0:
                        ny, nx = move(dr, y, x)
                        if (ny, nx) not in visited and data[ny, nx] != 9:
                            nv.add((ny, nx))
            if len(nv) == 0:
                #print(i, visited)
                break
            visited.update(nv)
            pts = list(nv)
        size[i] = len(visited)
    sz = list(sorted(size))
    return sz[-1] * sz[-2] * sz[-3]


assert part2(td) == 1134
print("PART2:", part2(data))
