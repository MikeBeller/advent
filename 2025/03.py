from a import *
inp = Lines(Rd("03.txt"))

print(sum(
    max(int(s[i])*10+int(s[j])
      for i in range(len(s)-1)
      for j in range(i+1,len(s))) 
        for s in inp
))

def jolt(s):
  mxs = []
  j = 0
  for i in range(12,0,-1):
    mxi = max(range(j,len(s)-i+1), key=lambda x: s[x])
    mxs.append(s[mxi])
    j = mxi + 1
  return int("".join(mxs))

assert jolt("234234234234278") == 434234234278

print(sum(jolt(s) for s in inp))