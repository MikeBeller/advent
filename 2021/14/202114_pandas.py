from timeit import timeit
import numpy as np
import pandas as pd
from io import StringIO


def parse(instr):
    start, rest = instr.split("\n\n")
    cmds = (pd.read_table(StringIO(rest), sep=" -> ",
                          names=('pr', 'ch'), index_col='pr', engine='python')
            .sort_index())
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


def step(cts):
    new_pairs = pd.concat([
        pd.DataFrame({'pr': cts.p1.values, 'c': cts.c.values}),
        pd.DataFrame({'pr': cts.p2.values, 'c': cts.c.values})
    ]).groupby('pr').sum()
    cts.c = 0
    cts.c = cts.c.add(new_pairs.c, fill_value=0).astype('Int64')
    return cts


def pairs(s):
    return [s[i:i+2] for i in range(len(s)-1)]


def part1(start, cmds, nsteps):
    cts = cmds
    cts['c'] = 0
    cts['p1'] = cts.index.str[0] + cts.ch
    cts['p2'] = cts.ch + cts.index.str[1]
    start_counts = pd.value_counts(list(pairs(start)))
    cts.c = cts.c.add(start_counts, fill_value=0).astype('Int64')
    for nstep in range(nsteps):
        cts = step(cts)

    lcs = pd.concat([
        pd.DataFrame({'l': cts.index.str[0].values, 'c': cts.c.values}),
        pd.DataFrame({'l': cts.index.str[1].values, 'c': cts.c.values}),
    ]).groupby('l').sum()
    lcs.loc[start[0], 'c'] += 1
    lcs.loc[start[-1], 'c'] += 1
    lcs.c //= 2
    return lcs.c.max() - lcs.c.min()


part2 = part1

assert part1(tstart, tcmds, 10) == 1588
print("PART1:", part1(start, cmds, 10))
assert part2(tstart, tcmds, 40) == 2188189693529
print("PART2:", part2(start, cmds, 40))

# this is quite a bit slower than the regular python code
# profiling seems to indicate the groupby is slow
#print(timeit("part2(start, cmds, 40)", number=3, globals=globals()))
