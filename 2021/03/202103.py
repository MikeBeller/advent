import numpy as np

tds = """00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"""


def parse(instr):
    return np.vstack([
        np.frombuffer(bytes(s, encoding='utf8'), dtype=np.int8) - 48
        for s in instr.splitlines()])


td = parse(tds)
data = parse(open("input.txt").read())


def bin_to_int(a):
    ln = len(a)
    ps = np.power(2, np.arange(ln-1, -1, -1))
    return (ps * a).sum()


assert bin_to_int(np.array([1, 0, 1, 1])) == 11


def part1(data):
    gamma = np.where(data.mean(axis=0) >= 0.5, 1, 0)
    epsilon = 1 - gamma
    return bin_to_int(gamma) * bin_to_int(epsilon)


assert part1(td) == 198
print("PART1:", part1(data))


def rating(data, type="o2"):
    d = data.copy()
    i = 0
    while d.shape[0] > 1:
        mn = d[:, i].mean() >= 0.5
        b = mn if type == 'o2' else ~mn
        d = d[d[:, i] == b, :]
        i += 1
    return d[0]


def part2(data):
    o2 = rating(data, 'o2')
    co2 = rating(data, 'co2')
    return bin_to_int(o2) * bin_to_int(co2)


assert part2(td) == 230

print("PART2:", part2(data))
