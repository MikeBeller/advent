import sys
from collections import defaultdict
import numpy as np
import pandas as pd

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
    return pd.DataFrame(data,columns=['g','s','e'])

def main():
    df = read_input()
    df['nt'] = df.e - df.s
    tt = df.groupby('g')
    mxg = tt['nt'].sum().idxmax()

    s = np.zeros(60, dtype=np.int32)
    for i,r in tt.get_group(mxg).iterrows():
        s[np.arange(r.s, r.e)] += 1
    mxm = s.argmax()

    print(mxm * mxg)

if __name__ == '__main__':
    main()

