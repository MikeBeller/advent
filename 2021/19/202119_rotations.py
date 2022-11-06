import numpy as np
from scipy.spatial.transform import Rotation as R
from typing import NamedTuple


def get_rotations() -> list[np.ndarray]:
    base_rotations = [('z', [0]), ('z', [180])]
    for xr in [0, 90, 180, 270]:
        base_rotations.append(('zx', [90, xr]))
    all_rotations = []
    for br in base_rotations:
        for yr in [0, 90, 180, 270]:
            axs, angs = br
            r = (axs + 'y', angs + [yr])
            all_rotations.append(r)
    return [
        (R.from_euler(axs, angs, degrees=True)
          .as_matrix()
          .round(10)
          .astype(int))
        for axs, angs in all_rotations]


ROTATIONS = get_rotations()


a = np.vstack([r @ np.array([1, 2, 3]).T for r in ROTATIONS])
t = [tuple(a[i,:]) for i in range(a.shape[0])]
for r in sorted(t):
    print(r)
import sys
sys.exit(0)

class Scanner(NamedTuple):
    id: int
    beacons: np.ndarray


def parse(instr) -> list[Scanner]:
    scs = []
    for scstr in instr.split("\n\n"):
        lines = scstr.splitlines()
        nid = int(lines[0].split()[2])
        pts = np.loadtxt(lines[1:], delimiter=',', dtype=int)
        scs.append(Scanner(id=nid, beacons=pts))
    return scs


td = parse(open("tinput.txt").read())
print(td)


# def part1(data):
#     rotations = get_rotations()
#     for sc1 in data[:-1]:
#         for sc2 in data[i:]:
#             sc2rl = find_orientation(sc1, sc2, rotations)
#             if sc2rl is not None:
#                 oriented_scanners.append(sc2rl)
#     # find all overlaps of oriented scanners?
#     assert False, "finish me"


# def find_orientation(sc1, sc2, rotations):
#     for i, r in rotations:
#         sc2r = rotate(sc2, r)
#         for p1 in sc1.list:
#             for p2 in sc2.list:
#                 delta = diff(p1, p2)
#                 sc2rl = translate(sc2r, delta)
#                 if num_overlapping(sc1, sc2rl) >= 12:
#                     return
#     return None
