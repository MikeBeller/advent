
def cvt(c):
    return 1 if c == '#' else 0


def isize(img):
    return len(img), len(img[0])


def pad(img, n):
    nr, nc = isize(img)
    nnr, nnc = nr + 2*n, nc + 2*n
    pimg = [[0] * nnc for _ in range(nnr)]
    for r in range(nr):
        for c in range(nc):
            pimg[r+n][c+n] = img[r][c]
    return pimg


def expand(field, margin):
    min_r, max_r, min_c, max_c = field
    return min_r - margin, max_r + margin, min_c - margin, max_c + margin


def show(img):
    nr, nc = isize(img)
    for r in range(nr):
        print(f"{r:03} ", sep="", end="")
        for c in range(nc):
            ch = '#' if img[r][c] == 1 else "."
            print(ch, sep='', end='')
        print()
    print()


def parse(instr):
    alg_s, img_s = instr.split("\n\n")
    alg = [cvt(c) for c in alg_s]
    assert len(alg) == 512, "alglen"
    img = {}
    lines = img_s.splitlines()
    nr = len(lines)
    nc = len(lines[0])
    for r, line in enumerate(lines):
        img[r] = {}
        for c, ch in enumerate(line):
            v = cvt(ch)
            img[r][c] = v
    return alg, img


talg, timg = parse(open("tinput.txt").read())


def enhance(alg, img, n_rounds):
    nr, nc = isize(img)
    for round in range(n_rounds):
        eimg = [[0] * nc for _ in range(nr)]
        default_val = 1 if alg[0] == 1 and round % 2 == 1 else 0
        for r in range(nr):
            for c in range(nc):
                n = 0
                for ri in range(-1, 2):
                    for ci in range(-1, 2):
                        rr = r + ri
                        cc = c + ci
                        p = default_val
                        if rr >= 0 and rr < nr and cc >= 0 and cc < nc:
                            p = img[rr][cc]
                        n = 2 * n + p
                p = alg[n]
                eimg[r][c] = p
        img = eimg
    return img


def part1(alg, img):
    img = pad(img, 4)
    enhanced_img = enhance(alg, img, 2)
    return sum(sum(r) for r in enhanced_img)


assert part1(talg, timg) == 35
alg, img = parse(open("input.txt").read())
print("PART1:", part1(alg, img))


def part2(alg, img):
    img = pad(img, 55)
    enhanced_img = enhance(alg, img, 50)
    return sum(sum(r) for r in enhanced_img)


assert part2(talg, timg) == 3351
print("PART2:", part2(alg, img))
