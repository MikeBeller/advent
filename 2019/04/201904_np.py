import numpy as np

tens = 10 ** np.arange(5, -1, -1)
#ns = np.c_[[ 111111, 223450, 123789,] ]
#ns = np.c_[[ 112233, 123444, 111122,] ]
ns = np.c_[np.arange(136818, 685980)]

ds = ns // tens % 10
df = ds[:,1:]-ds[:,:-1]
part1 = np.all(df > -1, axis=1) & np.any(df == 0, axis=1)
ds1 = ds[part1]
df1 = df[part1]
print("Part 1:", len(ds1))

o = np.ones((len(ds1),1))
dfm = np.hstack([o, df1, o])
part2 = np.any((dfm[:,:-2]!=0)&(dfm[:,1:-1]==0)&(dfm[:,2:]!=0), axis=1)
ds2 = ds1[part2]
print("Part 2:", len(ds2))
