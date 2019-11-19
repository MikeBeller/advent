import sys
import itertools
import numpy as np

def read_input():
    data = []
    for line in sorted(sys.stdin):
        f = line.strip().split()
        dt = f[0][1:]
        tm = f[1][:-1]
        if f[2] == "Guard":
            data.append(dict(date=dt, time=tm, cmd='start', gid=f[3]))
        elif f[2] == 'falls':
            data.append(dict(date=dt, time=tm, cmd='sleep'))
        elif f[2] == 'wakes':
            data.append(dict(date=dt, time=tm, cmd='wake'))
        else:
            assert False

    return data

def extract_minute(d):
    if d['time'][:2] == '23':
        return 0
    else:
        m = int(d['time'][3:])
        if m == 0 and d['time'][:2] == '01':
            m = 60
        return m

def main():
    data = read_input()

    # partition by day -- each day starts with a 'start'
    # - assume early starts have hour 23 and should move to 00:00
    # - assume no times for date X are after 01:00
    groups = []
    gr = None
    for d in data:
        if d['cmd'] == 'start':
            if gr:
                groups.append(gr)
            gr = [d]
        else:
            gr.append(d)
    
    # Simplify each day to a set of [wake,sleep] intervals
    days = []
    for gr in groups:
        m = extract_minute(gr[0])
        r = [[m]]
        for d in gr[1:]:
            if d['cmd'] == 'sleep':
                r[-1].append(extract_minute(d))
                if r[-1][0] > r[-1][1]:
                    assert "WTF"
            elif d['cmd'] == 'wake':
                r.append([extract_minute(d)])
        r[-1].append(60)
        days.append(dict(gid=gr[0]['gid'], intervals=r))

    # Now group by guard and find most sleepy guard
    gidkey = lambda d: d['gid']
    gidtb = {}
    mx = -1
    mxid = ''
    for k,g in itertools.groupby(sorted(days,key=gidkey), key=gidkey):
        gidtb[k] = dict(gid=k, days=list(g))
        s = 0
        print(k)
        for d in gidtb[k]['days']:
            s += 60 - sum(y-x for x,y in d['intervals'])
            print("adding", d['intervals'])
        print(k,s)
        if s > mx:
            mx = s
            mxid = k
            print("new max", mx, mxid)
    print("max", mxid, mx)

    # Now find most popular minute for that guard to be asleep
    a = np.zeros(60, dtype=np.int32)
    for d in gidtb[mxid]['days']:
        for i in d['intervals']:
            a[np.arange(i[0],i[1])] += 1
    print(a)
    argmx = np.argmax(a)
    print(int(mxid[1:]) * argmx)


if __name__ == '__main__':
    main()

