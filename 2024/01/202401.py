def parse_input(s):
    ps = [line.strip().split() for line in s.splitlines()]
    return [int(p[0]) for p in ps], [int(p[1]) for p in ps]

tinput = parse_input(open("tinput.txt").read().strip())
input = parse_input(open("input.txt").read().strip())

def part1(inp):
    return sum(abs(a-b) for a,b in zip(sorted(inp[0]), sorted(inp[1])))
assert part1(tinput) == 11
print(part1(input))

from collections import Counter
def part2(inp):
    bd = Counter(inp[1])
    return sum(bd[x] * x for x in inp[0])
assert part2(tinput) == 31
print(part2(input))