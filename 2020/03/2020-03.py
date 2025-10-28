from math import prod
inp=open("input.txt").read().splitlines()
nr,nc=len(inp),len(inp[0])
treeslope = lambda dr,dc: sum(
        1 for i in range(nr) if inp[(i*dr) % nr][(i*dc) % nc] == "#"
        and i*dr < nr)
print(treeslope(1,3))
print(prod(treeslope(dr,dc) for dr,dc in [(1,1),(1,3),(1,5),(1,7),(2,1)]))

