tinput = open("tinput.txt").read().splitlines()
input = open("input.txt").read().splitlines()

priority = {k:(v+1) for v,k in enumerate("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")}

def part1(lines):
    score = 0
    for line in lines:
        ln2 = len(line)//2
        a,b = set(line[:ln2]), set(line[ln2:])
        r = a & b
        assert len(r) == 1
        score = score + priority[list(r)[0]]
    return score

assert part1(tinput) == 157
print("PART1:", part1(input))

def part2(lines):
    score = 0
    for i in range(0, len(lines)-2, 3):
        a,b,c = [set(lines[j]) for j in range(i, i+3)]
        r = a & b & c
        assert len(r) == 1
        score = score + priority[list(r)[0]]
    return score

assert part2(tinput) == 70
print("PART2:", part2(input))