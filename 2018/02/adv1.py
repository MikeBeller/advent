import sys
from collections import defaultdict

def main():
    twos = 0
    threes = 0
    for line in sys.stdin:
        s = line.strip()
        cs = defaultdict(int)
        for c in s:
            cs[c] += 1
        vs = set(cs.values())
        if 2 in vs:
            twos += 1
        if 3 in vs:
            threes += 1
    print(twos * threes)


if __name__ == '__main__':
    main()
