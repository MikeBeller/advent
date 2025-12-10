from a import *
lns = Lines(Rd("06.txt"))
nr = len(lns) - 1

def part1(lns):
    ns = [[int(s) for s in l.strip().split()]
            for l in lns[:nr]]
    ops = lns[-1].split()

    tot = 0
    for i in range(len(ops)):
        nums = [ns[j][i] for j in range(nr)]
        tot += sum(nums) if ops[i] == "+" else Prod(nums)
    print(tot)

def part2(lns):
    dlns = lns[:nr-1]
    ops = lns[-1]
    nc = len(lns[0])
    c = nc - 1
    nums = []
    while c > 0:
        num = 0


