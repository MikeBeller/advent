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


def fire(target: Tuple[int, int, int, int], vx: int, vy: int) -> Optional[Tuple[int, int]]:
    x, y = 0, 0
    tx1, tx2, ty1, ty2 = target
    while x <= tx2 and y >= ty1:
        print(x, y)
        if x >= tx1 and x <= tx2 and y >= ty1 and y <= ty2:
            return (x, y)
        x += vx
        y += vy
        if x > 0:
            vx -= 1
        else:
            vx += 1
        vy -= 1
    return None


print(fire(td, 7, 2))
assert fire(td, 7, 2) != None
assert fire(td, 6, 3) != None
assert fire(td, 9, 0) != None
assert fire(td, 17, -4) == None
