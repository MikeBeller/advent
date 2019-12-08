from typing import List

def layers(buf: str) -> List[List[int]]:
    llen = 25 * 6
    ls: List[List[int]] = []
    p = 0
    while p < len(buf):
        ls.append(list(int(d) for d in buf[p:p+llen]))
        p += llen
    return ls

def part_one(inp: str) -> int:
    ls = layers(inp)
    lmin = min(ls, key=lambda l: sum(d == 0 for d in l))
    return sum(d == 1 for d in lmin) * sum(d == 2 for d in lmin)

def main():
    inp = open("input.txt").read().strip()
    ans1 = part_one(inp)
    print(ans1)

if __name__ == '__main__':
    main()

