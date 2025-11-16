from numpy import loadtxt, log10, concat, where

xs = loadtxt("input.txt",dtype=int)

def blink(xs):
    m1 = xs == 0
    nd = where(m1, 1, (1 + log10(xs)).astype(int))
    m2 = nd % 2 == 0
    m3 = ~ (m1 | m2)
    a = xs[m1] + 1
    nd2 = nd[m2]
    mod = 10 ** (nd2//2)
    xs2 = xs[m2]
    b = xs2 // mod
    c = xs2 % mod
    d = xs[m3] * 2024
    return concat([a,b,c,d])


def main(xs):
    for i in range(25):
        #print(i, len(xs))
        xs = blink(xs)
    print(len(xs))

main(xs)