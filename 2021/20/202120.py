
def cvt(c):
    return 1 if c == '#' else 0


def minmax(xs):
    xs = list(xs)
    return min(xs), max(xs)


def ranges(img):
    keys = [k for k, v in img.items() if v == 1]
    rmn, rmx = minmax(r for (r, _) in keys)
    cmn, cmx = minmax(c for (_, c) in keys)
    return range(rmn - 2, rmx + 3), range(cmn - 2, cmx + 3)


def show(img):
    rrange, crange = ranges(img)
    for r in rrange:
        print(f"{r:03} ", sep="", end="")
        for c in crange:
            ch = '#' if img.get((r, c), 0) else "."
            print(ch, sep='', end='')
        print()
    print()


def parse(instr):
    alg_s, img_s = instr.split("\n\n")
    alg = [cvt(c) for c in alg_s]
    img = {}
    for r, line in enumerate(img_s.splitlines()):
        for c, ch in enumerate(line):
            v = cvt(ch)
            img[(r, c)] = v
    return alg, img


talg, timg = parse(open("tinput.txt").read())


def enhance(alg, img):
    img2 = {}
    rrange, crange = ranges(img)
    for r in rrange:
        for c in crange:
            n = 0
            for ri in range(-1, 2):
                for ci in range(-1, 2):
                    n = 2 * n + img.get((r + ri, c + ci), 0)
            p = alg[n]
            img2[(r, c)] = p
    return img2


def part1(alg, img):
    show(img)
    img2 = enhance(alg, img)
    show(img2)
    img3 = enhance(alg, img2)
    show(img3)
    return sum(img3.values())


assert part1(talg, timg) == 35
alg, img = parse(open("input.txt").read())
print("PART1:", part1(alg, img))
