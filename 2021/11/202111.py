
import timeit


def parse(s):
    return [
        [int(c) for c in line]
        for line in s.splitlines()
    ]


tds = """5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526"""

td = parse(tds)
data = parse(open("input.txt").read())


def move(dr, r, c):
    if dr == 0:
        return r, c+1
    elif dr == 1:
        return r+1, c+1
    elif dr == 2:
        return r+1, c
    elif dr == 3:
        return r+1, c-1
    elif dr == 4:
        return r, c-1
    elif dr == 5:
        return r-1, c-1
    elif dr == 6:
        return r-1, c
    elif dr == 7:
        return r-1, c+1


def invalid(r, c):
    return r < 0 or r > 9 or c < 0 or c > 9


def print_board(m):
    for row in m:
        print(" ".join(str(i) for i in row))
    print()


DO_ALL = 999999999


def part1(data, nsteps):
    m = [row.copy() for row in data[:]]
    nflashed = 0
    for step in range(nsteps):
        all_flashed = set()
        for r in range(10):
            for c in range(10):
                m[r][c] += 1
                if m[r][c] == 10:
                    all_flashed.add((r, c))
        flashed = all_flashed.copy()
        while True:
            these = list(flashed)
            flashed = set()
            for r, c in list(these):
                for dr in range(8):
                    r2, c2 = move(dr, r, c)
                    if invalid(r2, c2):
                        continue
                    m[r2][c2] += 1
                    if m[r2][c2] == 10:
                        flashed.add((r2, c2))
            if len(flashed) == 0:
                break
            all_flashed.update(flashed)
        for (r, c) in all_flashed:
            assert m[r][c] >= 10
            m[r][c] = 0
        nflashed += len(all_flashed)
        #print("After step", step+1, ":")
        # print_board(m)
        if len(all_flashed) == 100 and nsteps == DO_ALL:
            break
    if nsteps == DO_ALL:
        return step + 1
    else:
        return nflashed


assert part1(td, 100) == 1656
print("PART1:", part1(data, 100))


def part2(data):
    return part1(data, DO_ALL)


assert part2(td) == 195
print("PART2:", part2(data))
