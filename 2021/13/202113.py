import numpy as np


def parse(instr):
    pts_s, fold_s = instr.strip().split("\n\n")
    pts = np.fliplr(np.loadtxt(pts_s.splitlines(),
                               delimiter=",", dtype=np.int32))
    shape = np.max(pts, axis=0) + 1
    a = np.zeros(shape, dtype=np.int32)
    rs = pts[:, 0]
    cs = pts[:, 1]
    a[rs, cs] = 1
    folds = []
    for line in fold_s.splitlines():
        _, _, pr = line.split()
        xy, ns = pr.split("=")
        folds.append((xy, int(ns)))
    return a, folds


tdata, tfolds = parse("""
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
""")

data, folds = parse(open("input.txt").read())


def fold(a, cmd):
    xy, n = cmd
    if xy == 'y':
        top = a[0:n, :]
        bottom = a[(n+1):, :]
        return top | np.flipud(bottom)
    else:
        left = a[:, 0:n]
        right = a[:, (n+1):]
        return left | np.fliplr(right)


def part1(data, folds):
    folded = fold(data, folds[0])
    return np.sum(folded)


assert part1(tdata, tfolds) == 17
print("PART1:", part1(data, folds))


def print_formatted(a):
    nr, nc = a.shape
    for r in range(nr):
        print("".join(
            ('#' if v == 1 else ' ') for v in a[r, :]
        ))


def part2(data, folds):
    a = data
    for fld in folds:
        a = fold(a, fld)
    print_formatted(a)
    return np.sum(a)


assert part2(tdata, tfolds) == 16
print("PART2:", part2(data, folds))
