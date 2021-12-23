import numpy as np


def parse(instr):
    return np.vstack([
        np.frombuffer(bytes(s, encoding='utf8'), dtype=np.int8) - 48
        for s in instr.splitlines()]).astype(np.int32)


td = parse("""
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
""".strip())
data = parse(open("input.txt").read())

INF = 999999999

RT, DN, LT, UP = 0, 1, 2, 3


def move(r, c, dr):
    if dr == RT:
        return r, c+1
    elif dr == DN:
        return r+1, c
    elif dr == LT:
        return r, c-1
    else:
        return r-1, c


def search(d):
    nr, nc = d.shape
    mn = np.full((nr, nc), INF, dtype=np.int32)
    sr, sc = 0, 0
    st = {(sr, sc): 0}
    min_len = INF
    while len(st) != 0:
        new_st = {}
        for (r, c), ln in st.items():
            for dr in [RT, DN, LT, UP]:
                r2, c2 = move(r, c, dr)
                if r2 >= 0 and c2 >= 0 and r2 < nr and c2 < nc:
                    ln2 = ln + d[r2, c2]
                    if (r2, c2) == ((nr-1), (nc-1)):
                        min_len = min(ln2, min_len)
                        #print("New min", min_len)
                        break
                    if ln2 < mn[r2, c2]:
                        new_st[(r2, c2)] = ln2
                        mn[r2, c2] = ln2
        st = new_st
    return min_len


def part1(d):
    return search(d)


def part2(d):
    nr, nc = d.shape
    NR, NC = 5*nr, 5*nc
    dd = np.zeros((NR, NC), dtype=np.int32)
    for i in range(5):
        for j in range(5):
            r, c = i * nr, j * nc
            dd[r:(r+nr), c:(c+nc)] = (d - 1 + i + j) % 9 + 1
    ln = search(dd)
    print(ln)
    return ln


assert part1(td) == 40
print("PART1:", part1(data))

assert part2(td) == 315
print("PART2:", part2(data))
