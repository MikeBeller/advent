import numpy as np


def parse(s):
    return np.loadtxt(s.replace(" -> ", ",").splitlines(),
                      delimiter=",", dtype=np.int32)


td = parse(open("tinput.txt").read())
data = parse(open("input.txt").read())


def part1(data, diag=False):
    x1, y1, x2, y2 = data[:, 0], data[:, 1], data[:, 2], data[:, 3]
    mx_x = max(x1.max(), x2.max())
    mx_y = max(y1.max(), y2.max())
    a = np.zeros((mx_y+1, mx_x+1), dtype=np.int32)
    for (x1, y1, x2, y2) in data:
        dx = -1 if x1 > x2 else 1
        dy = -1 if y1 > y2 else 1
        if y1 == y2:
            a[y1, x1:x2+dx:dx] += 1
        elif x1 == x2:
            a[y1:y2+dy:dy, x1] += 1
        else:
            if diag:  # diagonal included
                n = dx * (x2 - x1) + 1
                i = np.arange(n)
                a[y1 + i * dy, x1 + i * dx] += 1
    return (a > 1).sum()


assert part1(td) == 5
print("PART1:", part1(data))


def part2(data):
    return part1(data, diag=True)


assert part2(td) == 12
print("PART2:", part2(data))
