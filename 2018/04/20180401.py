import sys
import numpy as np

def read_input():
    data = []
    for line in sorted(sys.stdin):
        f = line.strip().split()
        d = dict(date=f[0][1:], time=f[1][:-1])
        if f[2] == "Guard":
            d['cmd'] = 'start'
            d['gid'] = f[3]
        elif f[2] == 'falls':
            d['cmd'] = 'sleep'
        elif v[3] == 'wakes':
            d['cmd'] = 'wake'
        else:
            assert False
        data.append(d)

    return data

def main():
    data = read_input()


