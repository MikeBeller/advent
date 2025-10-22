from numpy import array, meshgrid
inp = [int(s) for s in open("input.txt").read().splitlines()]
a = array(meshgrid(inp,inp)).T.reshape(-1,2)
print(a[a.sum(axis=1) == 2020][0].prod())
a = array(meshgrid(inp,inp,inp)).T.reshape(-1,3)
print(a[a.sum(axis=1) == 2020][0].prod())
