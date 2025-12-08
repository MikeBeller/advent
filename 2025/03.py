from a import *
inp = Lines(Rd("03.txt"))

print(sum(
    max(int(s[i])*10+int(s[j])
      for i in range(len(s)-1)
      for j in range(i+1,len(s))) 
        for s in inp
))

print(sum(
    max(int("".join(c)) for c in Combinations(s,12))
    for s in inp
))