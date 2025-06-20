
tinput = open("tinput.txt").read().strip()
input = open("input.txt").read().strip()

def expand(s: str) -> list[int]:
    r = []
    for i in range(len(s)):
        if i % 2 == 0:
            r.extend([i//2] * int(s[i]))
        else:
            r.extend([-1] * int(s[i]))
    return r


def fill(inp: list[int]) -> list[int]:
    r = inp[:]
    i = 0
    e = len(r)-1
    while i < e:
        if r[i] != -1:
            i += 1
            continue
        if r[e] == -1:
            e -= 1
            continue
        r[i],r[e] = r[e],r[i]
        i += 1
    return r

def checksum(xs):
    return sum(i * xs[i] for i in range(len(xs)) if xs[i] != -1)

def part1(inp: str) -> int:
    return checksum(fill(expand(inp)))

assert part1(tinput) == 1928
print(part1(input))
