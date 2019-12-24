from typing import Dict,NamedTuple, List, Set

class Point(NamedTuple):
    x: int
    y: int

class Node:
    def __init__(self, x: int, y: int, mark: str) -> None:
        self.loc = Point(x, y)
        self.mark = mark
        self.conns: Set[Node] = set()
        self.visited = False

test1 = """#########
#b.A.@.a#
#########"""

test2 = """########################
#f.D.E.e.C.b.A.@.a.B.c.#
######################.#
#d.....................#
########################"""

def move(p: Point, d: int) -> Point:
    if d == 0:
        return Point(p.x, p.y-1)
    elif d == 1:
        return Point(p.x+1, p.y)
    elif d == 2:
        return Point(p.x, p.y+1)
    elif d == 3:
        return Point(p.x-1, p.y)
    else:
        assert False, "Invalid direction"

def read_data(s: str) -> Dict[Point,Node]:
    r: Dict[Point,Node] = {}
    for y,line in enumerate(s.splitlines()):
        for x,c in enumerate(line.strip()):
            if c != '#':
                r[Point(x,y)] = Node(x, y, c)

    for p in r.keys():
        for i in range(4):
            q = move(p, i)
            if q in r:
                r[p].conns.add(r[q])
                r[q].conns.add(r[p])
    return r

d = read_data(test1)
print(d)



