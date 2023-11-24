data = [[int(x) for x in gs.splitlines()]
        for gs in open("input.txt").read().split('\n\n')]
gss = [sum(g) for g in data]
print(max(gss))
print(sum(list(sorted(gss))[-3:]))
