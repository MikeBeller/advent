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


def part1(draws, bs):
    for d in draws:
        bs[bs == d] = -1
        rs = bs.sum(axis=1)
        cs = bs.sum(axis=2)
        wh = np.argwhere((rs == -5) | (cs == -5))
        if len(wh) == 1:
            bi = wh[0, 0]
            #print("board", bi, "wins")
            wb = bs[bi, :, :]
            return d * wb[wb != -1].sum()


assert part1(draws_t, boards_t) == 4512
print("PART1:", part1(draws, boards))


def part2(draws, bs):
    wins = set()
    num_boards = bs.shape[0]
    for d in draws:
        bs[bs == d] = -1
        rs = bs.sum(axis=1)
        cs = bs.sum(axis=2)
        wh = np.argwhere((rs == -5) | (cs == -5))
        new_wins = wins | set(wh[:, 0])
        if len(new_wins) == num_boards:
            [bi] = list(new_wins - wins)
            #print("board", bi, "wins last")
            wb = bs[bi, :, :]
            return d * wb[wb != -1].sum()
        wins = new_wins


assert part2(draws_t, boards_t) == 1924
print("PART2:", part2(draws, boards))
