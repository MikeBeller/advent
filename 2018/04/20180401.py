import sys
import numpy as np
from datetime import datetime, timedelta

def read_input():
    data = []
    for line in sorted(sys.stdin):
        f = line.strip().split()
        d = dict(date=f[0][1:], time=f[1][:-1])
        dts = f[0][1:] + ' ' + f[1][:-1]
        dt = datetime.fromisoformat(dts)
        d = dict(dt=dt)
        if f[2] == "Guard":
            d['cmd'] = 'start'
            d['gid'] = f[3]
        elif f[2] == 'falls':
            d['cmd'] = 'sleep'
        elif f[2] == 'wakes':
            d['cmd'] = 'wake'
        else:
            assert False
        data.append(d)

    return data

def main():
    data = read_input()
    for d in data:
        if d['cmd'] == 'start':
            t = d['dt']

            # advance to start of shift
            while t.hour() == 23:
                t += timedelta(minutes=1)

            while t.hour() == 0:
                pass



if __name__ == '__main__':
    main()

