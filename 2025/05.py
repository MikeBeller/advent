from a import *
p=Rd("05.txt").split("\n\n")
rngs=[Parse("ii",line,sep="-") for line in Lines(p[0])]
ings=Map(int, Lines(p[1]))

def fresh(rngs,i):
    for b,e in rngs:
        if b <= i <= e:
            return True
    return False
    
print(sum(1 for i in ings if fresh(rngs, i)))

def part2(rngs):
    bs = list(sorted(r[0] for r in rngs))
    es = list(sorted(r[1] for r in rngs))
    ds = Ddict(int)
    for b in bs:
        ds[b] += 1
    for e in es:
        ds[e+1] -= 1
    tot = 0
    old = 0
    for k in sorted(ds.keys()):
        new = old + ds[k]
        if old == 0 and new != 0:
            start = k
        elif new == 0 and old != 0:
            tot += k - start
        old = new
    return tot


print(part2(rngs))
