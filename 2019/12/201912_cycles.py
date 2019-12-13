import numpy as np
from io import StringIO

def read_data(s):
    s = s.replace("x=","")
    s = s.replace("y=","")
    s = s.replace("z=","")
    s = s.replace("<","")
    s = s.replace(">","")
    s = s.replace(",","")
    inp = StringIO(s)
    return np.loadtxt(inp, dtype=np.int64)

mydtype = np.int64 

def cycle(pos):
    p = np.array(pos, dtype=mydtype)
    v = np.zeros(4, dtype=mydtype)
    r = {}
    num = 0
    while True:
        for i in range(4):
            v[i] += np.sum(np.sign(p - p[i]))
        p += v
        st = str(p) + str(v)
        if st in r:
            break
        r[st] = True
        num += 1
    return num

def multicycle(pos):
    rs = np.zeros(3, dtype=np.int64)
    for i in range(3):
        rs[i] = cycle(pos[:,i])
        print(rs[i])
    return np.lcm.reduce(rs)

test1 = np.array([
        [-1, 0, 2],
        [2, -10, -7],
        [4, -8, 8],
        [3, 5, -1]])
assert multicycle(test1) == 2772

def main():
    pos = read_data(open("input.txt").read())
    ans = multicycle(pos)
    print(ans)

main()

