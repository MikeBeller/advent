import numpy as np
import re

def read_data(inpath):
    pos = []
    vel = []
    for line in open(inpath):
        m = re.match(r"position=< *(-?[0-9]+), *(-?[0-9]+)> velocity=< *(-?[0-9]+), *(-?[0-9]+)>", line)
        if m:
            ms = [int(g) for g in m.groups()]
            pos.append([ms[0], ms[1]])
            vel.append([ms[2], ms[3]])
    return (np.array(pos), np.array(vel))

def metric(pos):
    mnx = np.amin(pos[:,0])
    mxx = np.amax(pos[:,0])
    mny = np.amin(pos[:,1])
    mxy = np.amax(pos[:,1])
    return -(mxx - mnx) * (mxy - mny)
    
def sim(pos, vel, n):
    lastmt = -999999999999999
    for i in range(n):
        pos += vel
        mt = metric(pos)
        if mt <= lastmt:
            pos -= vel
            np.savetxt("snappy.{}.csv".format(i-1), pos, fmt="%d", delimiter=',')
            break
        lastmt = mt
    return i-1

def main():
    pos,vel = read_data("input.txt")
    r = sim(pos, vel, 20000)
    print(r)

main()

