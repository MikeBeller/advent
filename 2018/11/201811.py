import numpy as np

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

def filter_pl(m: np.ndarray, sq: int) -> np.ndarray:
    a = np.zeros((SIZE-sq, SIZE-sq), dtype=np.int64)
    for r in range(SIZE - sq):
        for c in range(SIZE - sq):
            a[c,r] = np.sum(m[c:c+sq,r:r+sq])
    return a

def part1(sn: int):
    pl = power_level(sn)
    a = filter_pl(pl, 3)
    ind = np.argmax(a)
    r,c = np.unravel_index(ind, a.shape)
    return c+1, r+1

assert part1(18) == (33,45)

def main():
    ans1 = part1(3999)
    print("PART1:", ans1)

main()

