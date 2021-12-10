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

digit_code = ['abcefg', 'cf', 'acdeg', 'acdfg', 'bcdf',
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

known = np.array([1, 4, 7, 8])
unknown = np.array([0, 2, 3, 5, 6, 9])


def overlap_matrix(codes, known_inds, unknown_inds):
    def f(a, b):
        return np.sum(codes[a, :] & codes[b, :])
    f_uf = np.frompyfunc(f, 2, 1)
    return f_uf.outer(known_inds, unknown_inds)


# Calculate the "overlap matrix" between the known digits (1, 4, 7, 8), and the unknown ones (0, 2, 3, 5, 6, 9)
digit_codes = np.array([encode(s) for s in digit_code])


def find_column(matrix, col):
    for i in range(matrix.shape[1]):
        if np.all(matrix[:, i] == col):
            return i
    assert False, "not found"


def ssort(s):
    return "".join(sorted(s))


def part2(data):
    sm = 0
    std_ovm = overlap_matrix(digit_codes, known, unknown)
    print(std_ovm)
    for instrs, outstrs in data:
        print(instrs, outstrs)
        ins, _ = encode_case([instrs, outstrs])
        lc = len_c[ins.sum(axis=1)]
        (known_inds,) = np.nonzero(lc != -1)
        k_i = np.argsort(lc[lc != -1])
        k_ii = known_inds[k_i]
        print(lc, known_inds, k_ii)
        (unknown_inds,) = np.nonzero(lc == -1)
        print("UK", unknown_inds)
        u_ii = unknown_inds
        ovm = overlap_matrix(ins, k_ii, u_ii)
        u_iii = [find_column(ovm, std_ovm[:, i]) for i in range(len(unknown))]
        u_iiii = unknown[u_iii]
        print(ovm, u_iii, u_iiii)
        p = np.zeros(10, dtype=np.int32)
        p[k_ii] = known
        p[u_ii] = u_iiii
        print(p)
        tx = {ssort(istr): ind for istr, ind in zip(instrs, p)}
        for ostr in outstrs:
            sostr = ssort(ostr)
            print(sostr, tx[sostr])
        sm += 1

    return sm


print(part2(td))
