import numpy as np
import scipy.spatial.transform.Rotation as R
from collections import namedtuple

def get_rotations():
    rs = []
    base_rotations = [('z', 0), ('z', 180)]
    for xr in [0, 90, 180, 270]:
        base_rotations.append(('zx', [90, xr]))
    all_rotations = []
    for br in base_rotations:
        for yr in [0, 90, 180, 270]:
            axs, angs = br
            r = (axs + 'y', angs + [yr])
            all_rotations.append(r)
    return [R.from_euler(axs, angs, degrees=True) for axs,angs in all_rotations]

print(get_rotations())
  
Scanner = namedtuple('Scanner', ['num', 'list', 'rot'])

def part1(data):
    rotations = get_rotations()
    for sc1 in data[:-1]:
        for sc2 in data[i:]:
            sc2rl = find_orientation(sc1, sc2, rotations)
            if sc2rl is not None:
                oriented_scanners.append(sc2rl)
    # find all overlaps of oriented scanners?
    assert False, "finish me"

def find_orientation(sc1, sc2, rotations):
    for i,r in rotations:
        sc2r = rotate(sc2, r)
        for p1 in sc1.list:
            for p2 in sc2.list:
                delta = diff(p1, p2)
                sc2rl = translate(sc2r, delta)
                if num_overlapping(sc1, sc2rl) >= 12:
                    return
    return None

