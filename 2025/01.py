inp = [(s[0],int(s[1:])) for s in open("01.txt").read().splitlines()]

def part1(inp):
    tot = 50; c = 0
    for (sn,nm) in inp:
        tot = (tot + (-1 if sn == "L" else 1)*nm) % 100
        if tot == 0: c += 1
    return c

print(part1(inp))

def part2(inp):
    tot = 50; c = 0
    for (sn,nm) in inp:
        diff = (-1 if sn == "L" else 1) * nm
        new = (tot + diff) % 100
        c += abs(diff // 100)
    return c