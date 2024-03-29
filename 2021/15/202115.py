from timeit import timeit
from typing import List, Tuple


def parse(s: str) -> List[List[int]]:
    return [[int(c) for c in line]
            for line in s.splitlines()]


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


def move(r: int, c: int, dr: int) -> Tuple[int, int]:
    if dr == RT:
        return r, c+1
    elif dr == DN:
        return r+1, c
    elif dr == LT:
        return r, c-1
    else:
        return r-1, c


def search(d: List[List[int]]) -> int:
    nr, nc = len(d), len(d[0])
    mn = [([INF] * nc) for _ in range(nr)]
    sr, sc = 0, 0
    st = {(sr, sc): 0}
    min_len = INF
    while len(st) != 0:
        new_st = {}
        for (r, c), ln in st.items():
            for dr in [RT, DN, LT, UP]:
                r2, c2 = move(r, c, dr)
                if r2 >= 0 and c2 >= 0 and r2 < nr and c2 < nc:
                    ln2 = ln + d[r2][c2]
                    if (r2, c2) == ((nr-1), (nc-1)):
                        min_len = min(ln2, min_len)
                        #print("New min", min_len)
                        break
                    if ln2 < mn[r2][c2]:
                        new_st[(r2, c2)] = ln2
                        mn[r2][c2] = ln2
        st = new_st
    return min_len


def part1(d: List[List[int]]) -> int:
    return search(d)


def part2(d: List[List[int]]) -> int:
    nr, nc = len(d), len(d[0])
    NR, NC = 5*nr, 5*nc
    dd = [([0] * NC) for r in range(NR)]
    for i in range(5):
        for j in range(5):
            for r in range(nr):
                for c in range(nc):
                    v = (d[r][c] - 1 + i + j) % 9 + 1
                    dd[r + nr*i][c + nc*j] = v
    ln = search(dd)
    print(ln)
    return ln


assert part1(td) == 40
print("PART1:", part1(data))

assert part2(td) == 315
print("PART2:", part2(data))

print("Time for 3 runs:", timeit("part2(data)", number=3, globals=globals()))
