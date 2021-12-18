import numpy as np


def parse(instr):
    pts_s, fold_s = instr.strip().split("\n\n")
    pts = np.flip(np.loadtxt(pts_s.splitlines(),
                  delimiter=",", dtype=np.int32), axis=1)
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


def part1(data, folds, break_after_first=True):
    a = data.copy()
    for xy, n in folds:
        if xy == 'y':
            top = a[0:n, :]
            bottom = a[(n+1):, :]
            a = top | np.flip(bottom, axis=0)
        else:
            left = a[:, 0:n]
            right = a[:, (n+1):]
            a = left | np.flip(right, axis=1)
        # print(a)
        if break_after_first:
            break
    print(a)
    return np.sum(a)


assert part1(tdata, tfolds) == 17
print("PART1:", part1(data, folds))


def part2(data, folds):
    return part1(data, folds, break_after_first=False)


assert part2(tdata, tfolds) == 16
print("PART2:", part2(data, folds))
