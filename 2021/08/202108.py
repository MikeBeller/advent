import numpy as np


def parse(instr):
    rows = []
    for line in instr.splitlines():
        s1, s2 = line.split(" | ", 1)
        rows.append([s1.split(), s2.split()])
    return rows


td = parse("""be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce""")

data = parse(open("input.txt").read())

code = ['abcefg', 'cf', 'acdeg', 'acdfg', 'bcdf',
        'abdfg', 'abdefg', 'acf', 'abcdefg', 'abcdfg']
len_c = np.array([-1, -1, 1, 7, 4, -1, -1, 8], dtype=np.int8)


def encode(s):
    ix = np.frombuffer(bytes(s, encoding='utf8'), dtype=np.int8) - 97
    r = np.zeros(7, dtype=np.int8)
    r[ix] = 1
    return r


def encode_case(row):
    ins, outs = row
    return np.vstack([encode(i) for i in ins]), np.vstack([encode(o) for o in outs])


def part1(data):
    c = 0
    for row in data:
        _, outs = encode_case(row)
        ds = len_c[np.sum(outs, axis=1)]
        c += np.sum(ds != -1)
    return c


assert part1(td) == 26
print("PART1:", part1(data))
