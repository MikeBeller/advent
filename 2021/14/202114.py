from timeit import timeit
from collections import Counter


def parse(instr):
    start, rest = instr.split("\n\n")
    cmds = {}
    for line in rest.splitlines():
        pr, t = line.split(' -> ')
        cmds[(pr[0]), pr[1]] = t
    return start, cmds


tds = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C""".strip()

tstart, tcmds = parse(tds)
start, cmds = parse(open("input.txt").read())


def step(seq, cmds):
    r = []
    last = None
    for i in range(len(seq)-1):
        tpr = tuple(seq[i:i+2])
        first, last = tpr
        r.append(first)
        if tpr in cmds:
            r.append(cmds[tpr])
    r.append(last)
    return r


def part1(start, cmds, nsteps):
    seq = list(start)
    for st in range(nsteps):
        seq = step(seq, cmds)
        # print("".join(seq))
    cts = Counter(seq)
    cm = cts.most_common(len(cts))
    return cm[0][1] - cm[-1][1]


assert part1(tstart, tcmds, 10) == 1588
print("PART1:", part1(start, cmds, 10))


def pairs(s):
    return [s[i:i+2] for i in range(len(s)-1)]


def step2(cmds, cts):
    added = Counter()
    for pr, ct in cts.items():
        if pr in cmds:
            mc = cmds[pr]
            lc, rc = pr
            added[pr] -= cts[pr]
            added[lc + mc] += cts[pr]
            added[mc + rc] += cts[pr]
    return cts + added


def part2(start, cmds, nsteps):
    cmds = {(lc + rc): v for ((lc, rc), v) in cmds.items()}
    counts = Counter(pairs(start))
    for st in range(nsteps):
        counts = step2(cmds, counts)

    # convert counts to number of letters
    # every letter is part of two pairs except the first and last, which are
    # known at the beginning and don't change
    ccounts = Counter()
    for ((lc, rc), n) in counts.items():
        ccounts[lc] += n
        ccounts[rc] += n
    ccounts[start[0]] += 1
    ccounts[start[-1]] += 1
    for k in ccounts:
        assert ccounts[k] % 2 == 0
        ccounts[k] //= 2
    #print("TOTAL LEN:", sum(ccounts.values()))
    cm = ccounts.most_common(len(ccounts))
    return cm[0][1] - cm[-1][1]


assert part2(tstart, tcmds, 10) == 1588
assert part2(tstart, tcmds, 40) == 2188189693529
print("PART2:", part2(start, cmds, 40))

print(timeit("part2(start, cmds, 40)", number=3, globals=globals()))
