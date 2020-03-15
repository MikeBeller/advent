from typing import List, Tuple, DefaultDict, NamedTuple
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

def read_data(instr: str) -> Tuple[List[bytearray], List[Cart]]:
    track = [ bytearray(line.rstrip(), 'utf-8')
        for line in instr.splitlines()]
    carts: List[Cart] = []
    for y,row in enumerate(track):
        for x,c in enumerate(row):
            dr = DIRS.find(c)
            if dr >= 0:
                carts.append(Cart(dr, Point(x, y)))
                if dr in {EAST, WEST}:
                    row[x] = ord('-')
                else:
                    row[x] = ord('|')
    return (track, carts)

def tick(track: List[bytearray], carts: List[Cart]) -> Tuple[List[bytearray], List[Cart]]:
    for c in carts:
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
        #if nloc in [cc.loc for cc in carts]:
        #    return nloc
        c.loc = nloc

        ch = track[y][x]
        if ch == ord('+'):
            c.dr = (c.dr + c.state) % 4
            c.state = 0 if c.state == -1 else (1 if c.state == 0 else -1)
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
    carts.sort(key=lambda c: (c.loc.y, c.loc.x))
    return (track, carts)

def part1(instr: str) -> Point:
    track, carts = read_data(instr)
    while True:
        track, carts = tick(track, carts)
        for i in range(len(carts)-1):
            if carts[i].loc == carts[i+1].loc:
                return carts[i].loc

def test1():
    ins = open("tinput.txt").read()
    d,cs = read_data(ins)
    assert cs == [Cart(dr=1, loc=Point(2, 0), state=-1), Cart(dr=2, loc=Point(9, 3), state=-1)]

    assert part1(ins) == Point(7, 3)

test1()

def part2(instr: str) -> Point:
    track, carts = read_data(instr)

    # run ticks, eliminating both carts on crash, until there is only 1 cart
    while len(carts) > 1:
        track, carts = tick(track, carts)
        d: DefaultDict[Point,List[Cart]] = defaultdict(list)
        for c in carts:
            d[c.loc].append(c)
        carts = [cs[0] for cs in d.values() if len(cs) == 1]
        carts.sort(key=lambda c: (c.loc.y, c.loc.x))

    # run 1 tick as only cart
    track, carts = tick(track, carts)

    return carts[0].loc

def main() -> None:
    ins = open("input.txt").read()
    ans1 = part1(ins)
    print("PART1", ans1)

    ans2 = part2(ins)
    print("PART2", ans2)

main()

