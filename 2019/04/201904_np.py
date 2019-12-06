import numpy as np

tens = 10 ** np.arange(5, -1, -1)
#ns = np.c_[[ 111111, 223450, 123789,] ]
ns = np.c_[[ 112233, 123444, 111122,] ]
#ns = np.c_[np.arange(136818, 685980)]

ds = ns // tens % 10
df = ds[:,1:]-ds[:,:-1]
nondecreasing = np.all(df > -1, axis=1)
dsn = ds[nondecreasing]

print(dsn)
x = dsn[:,1:] != dsn[:,:-1]
#y = np.tile(np.arange(1,6), (len(dsn), 1)) * x
y = np.arange(1,6) * x

print(x)
print(y)
