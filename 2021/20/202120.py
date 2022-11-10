
def cvt(c):
    return 1 if c == '#' else 0


class Image:
    def __init__(self):
        self.data = {}
        self.min_r = float("inf")
        self.max_r = float("-inf")
        self.min_c = float("inf")
        self.max_c = float("-inf")

    def get(self, r, c):
        return self.data.get((r, c), 0)

    def set(self, r, c, v):
        self.min_r = min(r, self.min_r)
        self.max_r = max(r, self.max_r)
        self.min_c = min(c, self.min_c)
        self.max_c = max(c, self.max_c)
        self.data[(r, c)] = v

    def show(self):
        for r in range(self.min_r, self.max_r + 1):
            for c in range(self.min_c, self.max_c + 1):
                ch = '#' if self.get(r, c) else "."
                print(ch, sep='', end='')
            print()


def parse(instr):
    alg_s, img_s = instr.split("\n\n")
    alg = [cvt(c) for c in alg_s]
    img = Image()
    for r, line in enumerate(img_s.splitlines()):
        for c, ch in enumerate(line):
            v = cvt(ch)
            img.set(r, c, v)
    return alg, img


talg, timg = parse(open("tinput.txt").read())


def enhance(alg, img):
    img2 = Image()
    for r in range(img.min_r, img.max_r + 1):
        for c in range(img.min_c, img.max_c + 1):
            b = img.get(r, c)
            n = 0
            for ri in range(-1, 2):
                for ci in range(-1, 2):
                    n = 2 * n + img.get((r + ri, c + ci), 0)
                    print(r, c, n)
            p = alg[n]
            img2.set(r, c, p)
    return img2


def part1(alg, img):
    img2 = enhance(alg, img)
    img2.show()
    img3 = enhance(alg, img2)
    img3.show()
    print(img3.__dict__)
    return sum(img3.data.values())


print(part1(talg, timg))
