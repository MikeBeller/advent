tds = """forward 5
down 5
forward 8
up 3
down 8
forward 2"""


def parse(cmds):
    return [(c, int(v)) for c, v in
            [s.split() for s in cmds.strip().splitlines()]]


def part1(cmds):
    hp, d = 0, 0
    for c, v in cmds:
        if c == 'forward':
            hp += v
        elif c == 'down':
            d += v
        elif c == 'up':
            d -= v
    return hp * d


td = parse(tds)
data = parse(open("input.txt").read())
assert part1(td) == 150
print("PART1:", part1(data))


def part2(cmds):
    hp, d, aim = 0, 0, 0
    for c, v in cmds:
        if c == 'forward':
            hp += v
            d += aim * v
        elif c == 'down':
            aim += v
        elif c == 'up':
            aim -= v
    return hp * d


assert part2(td) == 900
print("PART2:", part2(data))
