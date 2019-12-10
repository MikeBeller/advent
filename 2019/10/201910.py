import math
from typing import List,Set,Dict,Tuple,Iterator
from collections import namedtuple
import itertools


Point = namedtuple('Point', ['x','y'])

def read_data(s: str) -> Set[Point]:
    ps: List[Point] = []
    for r,ln in enumerate(s.strip().split()):
        for c,ch in enumerate(ln):
            if ch == '#':
                ps.append(Point(c,r))
    return set(ps)

def is_on_line(p1: Point, p2: Point, p3: Point) -> bool:
    dxc = p3.x - p1.x
    dyc = p3.y - p1.y
    dxl = p2.x - p1.x
    dyl = p2.y - p1.y
    cross = dxc * dyl - dyc * dxl
    if cross != 0:
        return False
    
    if abs(dxl) >= abs(dyl):
        return p1.x <= p3.x <= p2.x if dxl > 0 else p2.x <= p3.x <= p1.x
    else:
        return p1.y <= p3.y <= p2.y if dyl > 0 else p2.y <= p3.y <= p1.y

def can_see(ps: Set[Point], p1: Point, p2: Point) -> bool:
    # check all possible blockers!
    for p3 in (ps - set([p1,p2])):
        if is_on_line(p1, p2, p3):
            return False
    return True

def part_one(ps: Set[Point]) -> Tuple[Point,int]:
    count: Dict[Point, int] = {}
    for p in ps:
        count[p] = 0

    for p1,p2 in itertools.combinations(ps, 2):
        if can_see(ps, p1, p2):
            count[p1] += 1
            count[p2] += 1

    return max(count.items(), key=lambda it: it[1])

def test_part_one(instr: str) -> int:
    ps = read_data(instr)
    g,count = part_one(ps)
    return count

assert test_part_one(".#..#\n.....\n#####\n....#\n...##") == 8
assert test_part_one("......#.#.  #..#.#....  ..#######.  .#.#.###..  .#..#.....  ..#....#.# #..#....#.  .##.#..### ##...#..#.  .#....####") == 33

def dist(p1: Point, p2: Point) -> float:
    return math.sqrt((p1.x - p2.x) ** 2 + (p1.y - p2.y) **2)

def bearing(gun: Point, target: Point) -> float:
    ux,uy = 0,-1
    vx,vy = target.x - gun.x, target.y - gun.y
    dot = ux * vx + uy * vy
    cos = dot / dist(gun, target)
    bearing = math.acos(cos) * 360/2/math.pi
    if target.x < gun.x:
        bearing = 360 - bearing
    return round(bearing,12)

assert bearing(Point(3, 3), Point(3, 2)) == 0
assert bearing(Point(3, 3), Point(4, 3)) == 90
assert round(bearing(Point(3, 3), Point(4, 2))) == 45
assert bearing(Point(3, 3), Point(2, 3)) == 270
assert round(bearing(Point(3, 3), Point(2, 2))) == 315

def part_two(ps: Set[Point], gun: Point) -> Iterator[Point]:
    targets = [(bearing(gun,p),dist(gun,p),p) for p in (ps - set([gun]))]
    targets.sort()

    grouped_targets = {bearing:list(group) for bearing,group in itertools.groupby(targets, lambda t: t[0])}
    n = 0
    p = (0, 0, Point(0,0))
    while grouped_targets:
        dels = []
        for a,g in grouped_targets.items():
            if len(g) != 0:
                n += 1
                p = g.pop(0)
                #print("Shooting", p, n)
                yield p[2]
            else:
                dels.append(a)
        for d in dels:
            del grouped_targets[d]

def test_part_two():
    ps = read_data(".#....#####...#..  ##...##.#####..## ##...#...#.#####.  ..#.....#...###..  ..#.#.....#....##")
    gun = Point(8,3)
    r = list(part_two(ps, gun))
    assert r[35] == Point(14,3)

    ps = read_data(".#..##.###...####### ##.############..##.  .#.######.########.# .###.#######.####.#.  #####.##.#.##.###.## ..#####..#.######### #################### #.####....###.#.#.## ##.################# #####.##.###..####..  ..######..##.####### ####.##.####...##..# .#####..#.######.### ##...#.##########...  #.##########.####### .####.#.###.###.#.## ....##.##.###..##### .#.#.###########.### #.#.#.#####.####.### ###.##.####.##.#..##")
    gun = Point(11,13)
    r = list(part_two(ps, gun))
    assert r[0] == Point(11,12)
    assert r[19] == Point(16, 0)
    assert r[298] == Point(11,1)

def main() -> None:
    instr = open("input.txt").read().strip()
    ps = read_data(instr)
    gun,cansee = part_one(ps)
    #gun,cansee = Point(22,25), 286
    print(gun, cansee)

    test_part_two()
    res = list(part_two(ps, gun))
    ans2 = res[199]
    print(ans2)
    print(ans2.x * 100 + ans2.y)

main()
