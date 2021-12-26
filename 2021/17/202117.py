import re
from typing import Optional, Tuple


def parse(instr: str) -> Tuple[int, int, int, int]:
    m = re.match(
        r"target area: x=(\-?\d+)[.][.](\-?\d+), y=(\-?\d+)[].][.](\-?\d+)",
        instr)
    assert m
    [x1, x2, y1, y2] = [int(v) for v in m.groups()]
    assert x1 < x2 and y1 < y2
    return (x1, x2, y1, y2)


td = parse("target area: x=20..30, y=-10..-5")
data = parse(open("input.txt").read())


def fire(target: Tuple[int, int, int, int], vx: int, vy: int) -> Optional[int]:
    x, y = 0, 0
    tx1, tx2, ty1, ty2 = target
    max_y = 0
    while x <= tx2 and y >= ty1:
        if x >= tx1 and x <= tx2 and y >= ty1 and y <= ty2:
            #print("HIT at", (x, y))
            return max_y
        x += vx
        y += vy
        if vx > 0:
            vx -= 1
        elif vx < 0:
            vx += 1
        vy -= 1
        if y > max_y:
            max_y = y
    #print("MISS at", (x, y))
    return None


assert fire(td, 7, 2) == 3
assert fire(td, 6, 3) == 6
assert fire(td, 9, 0) == 0
assert fire(td, 17, -4) == None


def part1(target: Tuple[int, int, int, int]) -> int:
    tx1, tx2, ty1, ty2 = target
    mxvx = tx2
    mxvy = 100
    mnvy = -100
    max_y = 0
    for vx in range(mxvx+1):
        for vy in range(mnvy, mxvy+1):
            mxy = fire(target, vx, vy)
            if mxy is not None and mxy > max_y:
                max_y = mxy
    return max_y


assert part1(td) == 45
print("PART1:", part1(data))


def part2(target: Tuple[int, int, int, int]) -> int:
    tx1, tx2, ty1, ty2 = target
    mxvx = tx2
    mxvy = 100
    mnvy = -100
    count = 0
    for vx in range(mxvx+1):
        for vy in range(mnvy, mxvy+1):
            mxy = fire(target, vx, vy)
            if mxy is not None:
                count += 1
    return count


assert part2(td) == 112
print("PART2:", part2(data))
