import sys
from collections import defaultdict
import numpy as np

def read_input():
    data = []
    g = None
    for line in sorted(sys.stdin):
        f = line.strip().split()
        t = int(f[1][-3:-1])
        if f[2] == "Guard":
            # deal with a shift that ends in sleeping
            if data and len(data[-1]) == 2:
                data[-1].append(60)
            g = int(f[3][1:])
        elif f[2] == 'falls':
            data.append([g, t])
        elif f[2] == 'wakes':
            data[-1].append(t)
    if data and len(data[-1]) == 1:
        data[-1].append(60)
    return data

def main():
    data = read_input()
    naps = defaultdict(list)
    for (g,s,e) in data:
        naps[g].append((s,e))

    most = [(g,sum(e-s for s,e in ns)) for (g,ns) in naps.items()]
    max_g,max_t = max(most, key=lambda x: x[1])
    print(max_g, max_t)

    m = np.zeros(60, dtype=np.int32)
    for n in naps[max_g]:
        m[n[0]:n[1]] += 1
    max_m = np.argmax(m)
    print(max_m)

    print (max_g * max_m)




if __name__ == '__main__':
    main()

