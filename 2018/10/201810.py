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

pos,vel = read_data("tinput.txt")
print(pos)
print(vel)

