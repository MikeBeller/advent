import numpy as np


def parse(s):
    """Output is draws,boards
    where: draws is a 1-d array of np.int32
           boards is a stack of 5x5 boards with indices (board, row, col)
    """
    f = s.split("\n\n")
    draws = np.fromstring(f[0], sep=',', dtype=np.int32)
    boards = [
        np.genfromtxt((r for r in bs.splitlines()), dtype=np.int32)
        for bs in f[1:]
    ]
    return draws, np.stack(boards, axis=0)


draws_t, boards_t = parse(open("tinput.txt").read())
assert boards_t.shape == (3, 5, 5)
draws, boards = parse(open("input.txt").read())


def part1(draws, bs, nth=1):
    nboards = bs.shape[0]
    wins = np.zeros(nboards, dtype=np.bool8)
    for d in draws:
        bs[bs == d] = -1
        rs = bs.sum(axis=1)
        cs = bs.sum(axis=2)
        new_wins = ((rs == -5) | (cs == -5)).any(axis=1)
        if new_wins.sum() == nth:
            [[bi]] = np.argwhere(new_wins ^ wins)
            #print("board", bi, "wins")
            wb = bs[bi, :, :]
            return d * wb[wb != -1].sum()
        wins = new_wins


assert part1(draws_t, boards_t) == 4512
print("PART1:", part1(draws, boards))


def part2(draws, bs):
    num_boards = bs.shape[0]
    return part1(draws, bs, nth=num_boards)


assert part2(draws_t, boards_t) == 1924
print("PART2:", part2(draws, boards))
