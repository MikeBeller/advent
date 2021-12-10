import numpy as np


def ssort(s):
    return "".join(sorted(s))


def parse(instr):
    rows = []
    for line in instr.splitlines():
        s1, s2 = line.split(" | ", 1)
        rows.append([[ssort(s) for s in s1.split()], [ssort(s)
                    for s in s2.split()]])
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

base_digit_codes = ['abcefg', 'cf', 'acdeg', 'acdfg', 'bcdf',
                    'abdfg', 'abdefg', 'acf', 'abcdefg', 'abcdfg']
len_map = {2: 1, 3: 7, 4: 4, 7: 8}


def part1(data):
    c = 0
    for _, outs in data:
        for out in outs:
            if len(out) in len_map:
                c += 1
    return c


assert part1(td) == 26
print("PART1:", part1(data))


def nover(s1, s2):
    return len(set(s1) & set(s2))


# compute mapping of overlap of each other digit with 1,4,7,8 respectively
# to the digit in the non-scrambled code
overlap = {}
for d in [0, 2, 3, 5, 6, 9]:
    overlap[tuple(nover(base_digit_codes[d], base_digit_codes[i])
                  for i in [1, 4, 7, 8])] = d


def part2(data):
    sm = 0
    for digit_codes, outs in data:
        code_to_digit = {}
        digit_to_code = {}

        # find 1,4,7,8
        other_codes = []
        for digit_code in digit_codes:
            ln = len(digit_code)
            if ln in len_map:
                code_to_digit[digit_code] = len_map[ln]
                digit_to_code[len_map[ln]] = digit_code
            else:
                other_codes.append(digit_code)

        # for remaining digits, find overlap with 1,4,7,8 and look up code
        for digit_code in other_codes:
            key = tuple(
                nover(digit_code, digit_to_code[i]) for i in [1, 4, 7, 8])
            d = overlap[key]
            code_to_digit[digit_code] = d
            # digit_to_code[d] = digit_code #don't need it

        r = 0
        for o in outs:
            r = r * 10 + code_to_digit[o]
        # print(r)
        sm += r
    return sm


assert part2(td) == 61229
print("PART2:", part2(data))
