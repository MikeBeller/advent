import sys
import itertools

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

    # Now group by guard
    gidkey = lambda d: d['gid']
    totals = []
    for k,g in itertools.groupby(sorted(days,key=gidkey), key=gidkey):
        s = 0
        for d in g:
            s += sum(y-x for x,y in d['intervals'])
        #print(k,s)
        totals.append((k,s))
    print("max", max(totals,key=lambda x: x[1]))






if __name__ == '__main__':
    main()

