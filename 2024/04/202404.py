from numpy import *
from scipy.signal import convolve2d

m = vstack([
    frombuffer(bytes(l, encoding='utf8'), int8)
    for l in open("input.txt").read().splitlines()
])
xm = array([ord(c) for c in "XMAS"], ndmin=2)
mx = flip(xm)
ps = [xm, xm.T, diagflat(xm), flip(diagflat(xm), axis=1),
      mx, mx.T, diagflat(mx), flip(diagflat(mx), axis=1)]
#for p in ps: print(p)
magic = sum(xm * xm)
print(sum([sum(convolve2d(m, p, mode='valid') == magic) for p in ps]))

ms = array([ord(c) for c in "MAS"])
sm = flip(ms)
pp = bitwise_or(diag(ms), flip(diag(sm), axis=1))
ps = [rot90(pp, k=n) for n in range(4)]
#for p in ps: print(p)
magic = sum(pp * pp)
print(sum([sum(convolve2d(m, p, mode='valid') == magic) for p in ps]))