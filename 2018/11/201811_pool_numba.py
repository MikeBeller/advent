import numpy as np
from typing import Tuple
import multiprocessing
import functools
from numba import njit

SIZE = 300  # size of the total playing field

def power_level(sn: int) -> np.ndarray:
    rid = np.arange(1,SIZE+1).reshape(1,SIZE) + 10
    yc = np.arange(1,SIZE+1).reshape(SIZE,1) 
    m = rid * yc
    m += sn
    m *= rid
    m = m // 100 % 10 - 5
    return m

assert power_level(8)[4,2] == 4
assert power_level(57)[78,121] == -5

@njit
def filter_pl(m: np.ndarray, sq: int) -> np.ndarray:
    a = np.zeros((SIZE-sq + 1, SIZE-sq + 1), dtype=np.int64)
    for r in range(SIZE - sq + 1):
        for c in range(SIZE - sq + 1):
            a[c,r] = np.sum(m[c:c+sq,r:r+sq])
    return a

def part1(sn: int):
    pl = power_level(sn)
    a = filter_pl(pl, 3)
    ind = np.argmax(a)
    r,c = np.unravel_index(ind, a.shape)
    return c+1, r+1

assert part1(18) == (33,45)

def filter_size(pl: np.ndarray, sz: int) -> Tuple[int,Tuple[int,int], int]:
    a = filter_pl(pl, sz)
    ind1d = np.argmax(a)
    ind = np.unravel_index(ind1d, a.shape)
    return (a[ind], ind, sz)

def part2(sn: int) -> Tuple[Tuple[int,int], int]:
    pl = power_level(sn)
    fsz = functools.partial(filter_size, pl)
    with multiprocessing.Pool(4) as pool:
        rs = pool.map(fsz, range(1,SIZE+1))
    (mxv,mxind,mxsz) = max(rs, key=lambda r: r[0])
    return (mxind[1]+1, mxind[0]+1), mxsz

#assert part2(18) == ((269, 90), 16)

def main():
    ans1 = part1(3999)
    print("PART1:", ans1)

    ans2 = part2(3999)
    print("PART2:", ans2)

if __name__ == '__main__':
    main()

