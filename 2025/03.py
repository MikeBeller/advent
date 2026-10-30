from a import *
inp = Lines(Rd("03.txt"))

def jolt(s, n):
  mxs = []
  j = 0
  for i in range(n,0,-1):
    mxi = max(range(j,len(s)-i+1), key=lambda x: s[x])
    mxs.append(s[mxi])
    j = mxi + 1
  n = int("".join(mxs))
  return n

assert jolt("234234234234278", 12) == 434234234278

print(sum(jolt(s, 2) for s in inp))
print(sum(jolt(s, 12) for s in inp))
