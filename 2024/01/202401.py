def parse_input(s):
    l1,l2 = [],[]
    for line in s.splitlines():
        a,b = line.strip().split()
        l1.append(int(a))
        l2.append(int(b))
    return l1, l2

def part1(inp):
    l1,l2 = inp
    return sum(abs(a-b) for a,b in zip(sorted(l1),sorted(l2)))

tinput = parse_input(open("tinput.txt").read().strip())
assert part1(tinput) == 11

input = parse_input(open("input.txt").read().strip())
print(part1(input))

from collections import Counter
def part2(inp):
    l1, l2 = inp
    l2d = Counter(l2)
    return sum(l2d[x] * x for x in l1)

assert part2(tinput) == 31
print(part2(input))