import numpy as np

def part1(mx):
    rid = np.arange(1,mx+1).reshape(1,mx) + 10
    yc = np.arange(1,mx+1).reshape(mx,1) 
    m = rid * yc
    print(m)

part1(10)


