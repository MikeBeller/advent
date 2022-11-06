from collections import Counter
from typing import NamedTuple, List


def cmp(a, b):
    return (a > b) - (a < b)


rotation_codes = ((-3, -2, -1), (-3, -1, 2), (-3, 1, -2), (-3, 2, 1), (-2, -3, 1), (-2, -1, -3), (-2, 1, 3), (-2, 3, -1), (-1, -3, -2), (-1, -2, 3), (-1, 2, -3),
                  (-1, 3, 2), (1, -3, 2), (1, -2, -3), (1, 2, 3), (1, 3, -2), (2, -3, -1), (2, -1, 3), (2, 1, -3), (2, 3, 1), (3, -2, 1), (3, -1, -2), (3, 1, 2), (3, 2, -1))
rotations = [
    ((abs(x)-1, abs(y)-1, abs(z)-1), (cmp(x, 0), cmp(y, 0), cmp(z, 0)))
    for x, y, z in rotation_codes]


class Point(NamedTuple):
    x: int
    y: int
    z: int


class Scanner(NamedTuple):
    num: int
    beacons: List[Point]
    loc: Point = None


def parse(instr):
    scanners = []
    for num, scanstr in enumerate(instr.split("\n\n")):
        beacons = frozenset(
            tuple(int(f) for f in line.strip().split(","))
            for line in scanstr.splitlines()[1:])
        scanners.append(Scanner(num, beacons, None))
    return scanners


tdata = parse(open("tinput.txt").read())


def align(adj, unadj):
    counter = Counter(
        (x1 - x2, y1 - y2, z1 - z2)
        for x1, y1, z1 in adj
        for x2, y2, z2 in unadj)
    [(delta, num)] = counter.most_common(1)
    return delta if num >= 12 else None


def rotate(b, rotation):
    ((mx, my, mz), (sx, sy, sz)) = rotation
    return tuple([sx * b[mx], sy * b[my], sz * b[mz]])


def rotate_all(bs, rotation):
    return frozenset(rotate(b, rotation) for b in bs)


assert rotate((5, 6, 7), rotations[7]) == (-6, 7, -5)

rotated_beacons = rotate_all(tdata[1].beacons, rotations[10])
assert align(tdata[0].beacons, rotated_beacons) == (68, -1246, -43), "align"


def align_one(aligned, unaligned):
    for u in unaligned:
        for rotation in rotations:
            rotated_beacons = rotate_all(u.beacons, rotation)
            for a in aligned:
                delta = align(a.beacons, rotated_beacons)
                if delta:
                    dx, dy, dz = delta
                    adjusted_beacons = frozenset(
                        (b[0] + dx, b[1] + dy, b[2] + dz)
                        for b in rotated_beacons
                    )
                    return Scanner(u.num, adjusted_beacons, delta), u
    return None


def align_all(scanners):
    aligned = set([scanners[0]._replace(loc=Point(0,0,0))])
    unaligned = set(scanners[1:])
    while unaligned:
        newly_aligned_beacon, old_beacon = align_one(aligned, unaligned)
        assert newly_aligned_beacon, "no alignment found"
        unaligned.remove(old_beacon)
        aligned.add(newly_aligned_beacon)
    return aligned


def part1(scanners):
    aligned = align_all(scanners)
    all_beacons = {b for s in aligned for b in s.beacons}
    return len(all_beacons), aligned

nscan, test_aligned_scanners = part1(tdata)
assert nscan == 79

def mdist(s1: Scanner, s2: Scanner):
    return sum(abs(a - b) for  a,b in zip(s1.loc, s2.loc))

def part2(scanners):
    dists = [mdist(s1, s2)
        for s1 in scanners
        for s2 in scanners]
    return max(dists)

assert part2(test_aligned_scanners) == 3621

data = parse(open("input.txt").read())

nscan, aligned_scanners = part1(data)
print("PART1:", nscan)

ans = part2(aligned_scanners)
print("PART2:", ans)
