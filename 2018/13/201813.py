from typing import List, Tuple, DefaultDict, NamedTuple, Set, Dict, Optional
from dataclasses import dataclass
from collections import defaultdict

DIRS = b'^>v<'

NORTH = 0
EAST = 1
SOUTH = 2
WEST = 3

class Point(NamedTuple):
    x: int
    y: int

@dataclass
class Cart:
    dr: int
    loc: Point
    state: int = -1

Track = List[bytearray]

def read_data(instr: str) -> Tuple[Track, Dict[Point,Cart]]:
    track = [ bytearray(line.rstrip(), 'utf-8')
        for line in instr.splitlines()]
    carts: Dict[Point,Cart] = {}
    for y,row in enumerate(track):
        for x,c in enumerate(row):
            dr = DIRS.find(c)
            if dr >= 0:
                cart = Cart(dr, Point(x, y))
                carts[cart.loc] = cart
                if dr in {EAST, WEST}:
                    row[x] = ord('-')
                else:
                    row[x] = ord('|')
    return (track, carts)

def track_with_carts(track: Track, carts: Dict[Point, Cart]):
    tr = [r[:] for r in track]
    for c in carts.values():
        cc = DIRS[c.dr]
        tr[c.loc.y][c.loc.x] = cc
    return "\n".join(r.decode() for r in tr)

def tick(
    track: Track,
    carts: Dict[Point, Cart],
    quit_on_crash: bool = False
    ) -> Tuple[Dict[Point,Cart], Optional[Point]]:

    deleted: Set[int] = set()
    for c in sorted(carts.values(), key=lambda c: (c.loc.y, c.loc.x)):
        if id(c) in deleted:
            continue
        x,y = c.loc.x, c.loc.y
        if c.dr == NORTH:
            y -= 1
        elif c.dr == EAST:
            x += 1
        elif c.dr == SOUTH:
            y += 1
        else:
            x -= 1

        assert x >= 0 and y >= 0 and y < len(track) and x < len(track[y])
        assert track[y][x] in b'|/\\-+'

        nloc = Point(x, y)
        if nloc in carts:
            # collision
            other = carts[nloc]
            deleted.add(id(other))
            deleted.add(id(c))
            del carts[nloc]
            del carts[c.loc]
            if quit_on_crash:
                return carts, nloc
            continue

        del carts[c.loc]
        c.loc = nloc
        carts[c.loc] = c

        ch = track[y][x]
        if ch == ord('+'):
            c.dr = (c.dr + c.state) % 4
            c.state = -1 if c.state == 1 else c.state + 1
        elif ch == ord('\\'):
            if c.dr == EAST or c.dr == WEST:
                c.dr = (c.dr + 1) % 4  # right turn
            else:
                c.dr = (c.dr - 1) % 4  # left turn
        elif ch == ord('/'):
            if c.dr == EAST or c.dr == WEST:
                c.dr = (c.dr - 1) % 4  # left
            else:
                c.dr = (c.dr + 1) % 4  # right

    return carts, None

def verify(carts: Dict[Point,Cart]):
    assert all(v.loc == k for k,v in carts.items())

def part1(instr: str, debug=False) -> Point:
    track, carts = read_data(instr)
    if debug: print("STARTING")
    if debug: print(track_with_carts(track, carts), "\n")
    while True:
        carts, crash_location = tick(track, carts, quit_on_crash=True)
        if debug:
            print(track_with_carts(track, carts))
            print(carts, "\n")
        if crash_location:
            return crash_location
        verify(carts)

def test1():
    ins = open("tinput.txt").read()
    assert part1(ins) == Point(7, 3)

test1()

def part2(instr: str, debug=False) -> Point:
    track, carts = read_data(instr)
    if debug: print(track_with_carts(track, carts), "\n")

    # run ticks, eliminating both carts on crash, until there is only 1 cart
    while len(carts) > 1:
        carts, _ = tick(track, carts, quit_on_crash=False)
        if debug: print(track_with_carts(track, carts), "\n")

    return list(carts.keys())[0]

def test2():
    ins = open("tinput2.txt").read()
    assert part2(ins) == Point(6, 4), "test2 failed"

test2()

def main() -> None:
    ins = open("input.txt").read()
    ans1 = part1(ins)
    print("PART1", ans1)

    ans2 = part2(ins)
    print("PART2", ans2)

main()

