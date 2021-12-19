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
print(part1(start, cmds, 10))


def pairs(s):
    return [s[i:i+2] for i in range(len(s)-1)]


def step2(cmds, cts):
    added = Counter()
    for pr, ct in cts.items():
        if pr in cmds:
            mc = cmds[pr]
            lc, rc = pr
            added[lc + mc] += cts[pr]
            added[mc + rc] += cts[pr]
    print(added)
    return cts + added


def part2(start, cmds, nsteps):
    print(cmds)
    # convert to string map
    cmds = {(lc + rc): v for ((lc, rc), v) in cmds.items()}
    cts = Counter(pairs(start))
    for st in range(nsteps):
        cts = step2(cmds, cts)
    cm = cts.most_common(len(cts))
    return cm[0][1] - cm[-1][1]


print(part2(tstart, tcmds, 10))
