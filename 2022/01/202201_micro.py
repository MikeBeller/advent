read = lambda s: open(s).read()
ints = lambda s: [int(x) for x in s.strip().splitlines()]
data = [ints(gs) for gs in read("input.txt").split('\n\n')]
gss = [sum(g) for g in data]
print(max(gss))
print(sum(list(sorted(gss))[-3:]))
