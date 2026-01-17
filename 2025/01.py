from a import *

inp = [ {'R': 1, 'L': -1}[s[0]]*int(s[1:]) for s in Lines(Rd("01.txt"))]
print(Count(Zero, Acc(lambda a,b: (a + b) % 100, inp, 50)))

# s = 50
# c = 0
# for line in open("01.txt").read().splitlines():
#     n = int(line[1:]) if line[0] == "R" else -int(line[1:])
#     s = (s + n) % 100
#     c += s == 0
# print(c)

def part2(inp):
    tot = 50; c = 0
    for nm in inp:
        dr = -1 if nm < 0 else 1
        for i in range(abs(nm)):
            tot += dr
            if tot % 100 == 0:
                c += 1
            tot = tot % 100
    return c

print(part2(inp))
