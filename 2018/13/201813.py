from typing import List, Tuple
from dataclasses import dataclass

DIRS = b'^>v<'

NORTH = 0
EAST = 1
SOUTH = 2
WEST = 3

@dataclass
class Point:
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

def run(instr: str) -> Point:
    track, carts = read_data(instr)
    print(carts)
    assert(len(carts) == 2)
    tick = 0
    while True:
        print(tick, carts)
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
            if nloc in [cc.loc for cc in carts]:
                print("Collision")
                return nloc
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
        tick += 1


ins = open("tinput.txt").read()
d,cs = read_data(ins)
assert cs == [Cart(dr=1, loc=Point(2, 0), state=-1), Cart(dr=2, loc=Point(9, 3), state=-1)]

def main() -> None:
    ins = open("tinput.txt").read()
    ans1 = run(ins)
    print("PART1", ans1)

main()

