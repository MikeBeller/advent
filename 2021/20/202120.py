
def cvt(c):
    return 1 if c == '#' else 0


def expand(field, margin):
    min_r, max_r, min_c, max_c = field
    return min_r - margin, max_r + margin, min_c - margin, max_c + margin


def show(img, field):
    min_r, max_r, min_c, max_c = field
    for r in range(min_r, max_r+1):
        print(f"{r:03} ", sep="", end="")
        for c in range(min_c, max_c+1):
            ch = '#' if img.get((r, c), 0) else "."
            print(ch, sep='', end='')
        print()
    print()


def parse(instr):
    alg_s, img_s = instr.split("\n\n")
    alg = [cvt(c) for c in alg_s]
    assert len(alg) == 512, "alglen"
    img = {}
    lines = img_s.splitlines()
    max_r = len(lines)
    max_c = len(lines[0])
    assert all(len(s) == max_c for s in lines), "grid"
    for r, line in enumerate(lines):
        for c, ch in enumerate(line):
            v = cvt(ch)
            img[(r, c)] = v
    return alg, img, (0, max_r, 0, max_c)


talg, timg, tfield = parse(open("tinput.txt").read())


def enhance(alg, img, field, round_n):
    min_r, max_r, min_c, max_c = field
    img2 = {}
    for r in range(min_r, max_r + 1):
        for c in range(min_c, max_c + 1):
            n = 0
            for ri in range(-1, 2):
                for ci in range(-1, 2):
                    rr = r + ri
                    cc = c + ci
                    default = 1 if alg[0] == 1 and round_n % 2 == 1 and ((rr < min_r or rr >= max_r) or (
                        cc < min_c or cc >= max_c)) else 0
                    n = 2 * n + img.get((r + ri, c + ci), default)
            p = alg[n]
            img2[(r, c)] = p
    return img2


def do_enhancement(alg, img, field, n_rounds):
    show(img, field)
    for i in range(n_rounds):
        img = enhance(alg, img, field, i)
    show(img, field)
    return img


def part1(alg, img, field):
    field = expand(field, 4)
    enhanced_img = do_enhancement(alg, img, field, 2)
    return sum(enhanced_img.values())


assert part1(talg, timg, tfield) == 35
alg, img, field = parse(open("input.txt").read())
print("PART1:", part1(alg, img, field))


def part2(alg, img, field):
    field = expand(field, 55)
    enhanced_img = do_enhancement(alg, img, field, 50)
    return sum(enhanced_img.values())


assert part2(talg, timg, tfield) == 3351
print("PART2:", part2(alg, img, field))
