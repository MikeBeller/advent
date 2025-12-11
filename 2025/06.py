from a import *
lns = open("06.txt").read().splitlines()

def part1(lns):
    nums = []
    nr = len(lns) - 1
    ns = [[int(s) for s in l.strip().split()]
            for l in lns[:nr]]
    ops = lns[-1].split()

    tot = 0
    for i in range(len(ops)):
        nums = [ns[j][i] for j in range(nr)]
        tot += sum(nums) if ops[i] == "+" else Prod(nums)
    print(tot)

part1(lns)

def part2(lns):
    nr = len(lns) - 1
    ops = lns[-1]
    nc = len(lns[0])
    c = nc - 1
    tot = 0
    while c > 0:
        nums = []
        while True:
            num = 0
            for r in range(nr):
                ch = lns[r][c]
                if ch != ' ':
                    num = (num * 10) + int(ch)
            nums.append(num)
            if (op := ops[c]) != ' ':
                tot += sum(nums) if op == '+' else Prod(nums)
                nums = []
                c -= 2
                break
            c -= 1
    print(tot)

part2(lns)


