import numpy as np

tens = 10 ** np.arange(5, -1, -1)
#ns = np.c_[[ 111111, 223450, 123789,] ]
#ns = np.c_[[ 112233, 123444, 111122,] ]
ns = np.c_[np.arange(136818, 685980)]

ds = ns // tens % 10
df = np.diff(ds, axis=1)
nondecreasing = np.all(df > -1, axis=1)
ns = ns[nondecreasing]
df = df[nondecreasing]

repeating = np.any(df == 0, axis=1)
ns = ns[repeating]
df = df[repeating]
print("Part1", len(ns))

zs = np.where(df == 0, 0, 1)
morethantwo = np.any(np.diff(zs) == 0, axis=1)
ns = ns[morethantwo == False]
print("Part2", len(ns))
