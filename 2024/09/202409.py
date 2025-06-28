from itertools import groupby

tinput = open("tinput.txt").read().strip()
input = open("input.txt").read().strip()


def expand(s: str) -> list[int]:
    r = []
    for i, si in enumerate(s):
        if i % 2 == 0:
            r.extend([i // 2] * int(si))
        else:
            r.extend([-1] * int(si))
    return r


def fill(inp: list[int]) -> list[int]:
    r = inp[:]
    i = 0
    e = len(r) - 1
    while i < e:
        if r[i] != -1:
            i += 1
            continue
        if r[e] == -1:
            e -= 1
            continue
        r[i], r[e] = r[e], r[i]
        i += 1
    return r


def checksum(xs):
    return sum(i * xs[i] for i in range(len(xs)) if xs[i] != -1)


def part1(inp: str) -> int:
    return checksum(fill(expand(inp)))


assert part1(tinput) == 1928
print(part1(input))

def blockit(xs):
    blocks = []
    i = 0
    for v,g in groupby(xs):
        l = len(list(g))
        blocks.append((i,v,l))
        i += l
    return blocks

def fill_full(inp: list[int]) -> list[int]:
    r = inp[:]
    blocks = [b for b in blockit(r) if b[1] != -1]
    for (bi,bn,bln) in reversed(blocks):
        spaces = [b for b in blockit(r) if b[1] == -1]
        for (si,_,sln) in spaces:
            if si >= bi:
                break
            if sln >= bln:
                r[si:si+bln] = r[bi:bi+bln]
                r[bi:bi+bln] = [-1]*bln
    return r


def part2(inp: str) -> int:
    return checksum(fill_full(expand(inp)))

assert part2(tinput) == 2858
print(part2(input))
