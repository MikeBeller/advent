from collections import namedtuple, Counter

def cmp(a, b):
    return (a > b) - (a < b) 

rotation_codes = ( (-3, -2, -1), (-3, -1, 2), (-3, 1, -2), (-3, 2, 1), (-2, -3, 1), (-2, -1, -3), (-2, 1, 3), (-2, 3, -1), (-1, -3, -2), (-1, -2, 3), (-1, 2, -3), (-1, 3, 2), (1, -3, 2), (1, -2, -3), (1, 2, 3), (1, 3, -2), (2, -3, -1), (2, -1, 3), (2, 1, -3), (2, 3, 1), (3, -2, 1), (3, -1, -2), (3, 1, 2), (3, 2, -1))
rotations = [
    ((abs(x)-1, abs(y)-1, abs(z)-1), (cmp(x,0), cmp(y, 0), cmp(z,0)))
    for x,y,z in rotation_codes]

Scanner = namedtuple('Scanner', ('num', 'beacons'))

def parse(instr):
    scanners = []
    for num,scanstr in enumerate(instr.split("\n\n")):
        beacons = frozenset(
            tuple(int(f) for f in line.strip().split(","))
            for line in scanstr.splitlines()[1:])
        scanners.append(Scanner(num, beacons))
    return scanners

tdata = parse(open("tinput.txt").read())
        
def align(adj, unadj):
    counter = Counter(
        (x1 - x2, y1 - y2, z1 - z2)
        for x1,y1,z1 in adj
        for x2,y2,z2 in unadj)
    [(delta, num)] = counter.most_common(1)
    return delta if num >= 12 else None

def rotate(b, rotation):
    ((mx, my, mz), (sx,sy,sz)) = rotations[rotation]
    return tuple([sx * b[mx], sy * b[my], sz * b[mz]])


def rotate_all(bs, rotation):
    return frozenset(rotate(b, rotation) for b in bs)

assert rotate((5,6,7), 7) == (-6, 7, -5)

rotated_beacons = rotate_all(tdata[1].beacons, 10)
print(align(tdata[0].beacons, rotated_beacons))
