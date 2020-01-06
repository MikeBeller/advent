from typing import Dict, NamedTuple, List, FrozenSet, Set, Tuple, Deque
from collections import deque

# Try to speed up the pypy version using integer lists instead of
# an articulated graph of nodes.  Did not help!

class Point(NamedTuple):
    x: int
    y: int

class Node:
    def __init__(self, x: int, y: int, mark: str) -> None:
        self.loc = Point(x, y)
        self.mark = mark
        self.conns: Set[Node] = set()

class Grid:
    def __init__(self, nr: int, nc: int):
        self.nr = nr
        self.nc = nc
        self.data = [0] * (nr * nc)

    def get(self, x: int, y: int) -> int:
        return self.data[y * self.nc + x]

    def set(self, x: int, y: int, v: int) -> None:
        self.data[y * self.nc + x] = v

def move(gr: Grid, p: Point, d: int) -> Tuple[Point, int]:
    if d == 0:
        p = Point(p.x, p.y-1)
    elif d == 1:
        p = Point(p.x+1, p.y)
    elif d == 2:
        p = Point(p.x, p.y+1)
    elif d == 3:
        p = Point(p.x-1, p.y)
    else:
        assert False, "Invalid direction"
    if p.x < 0 or p.x >= gr.nc or p.y < 0 or p.y >= gr.nr:
        return p, POUND
    else:
        return p, gr.get(p.x, p.y)

def read_data(s: str) -> Tuple[Grid, Dict[int,Point]]:
    lines = s.splitlines()
    nr = len(lines)
    nc = len(lines[0])
    gr = Grid(nr, nc)
    loc: Dict[int,Point] = {}

    for y,line in enumerate(lines):
        for x,c in enumerate(line):
            gr.set(x, y, ord(c))
            if c != '.':
                loc[ord(c)] = Point(x,y)

    return gr, loc

def is_key(c: int) -> bool:
    return c >= ord('a') and c <= ord('z')

def is_door(c: int) -> bool:
    return c >= ord('A') and c <= ord('Z')

class State(NamedTuple):
    pos: Point
    total_dist: int
    keys: FrozenSet[int]
    path: str

def key_for_door(c: int) -> int:
    return c + 32

def dist_to_keys_from(gr: Grid, st: State) -> Dict[int,int]:
    ds: Dict[int,int] = {}
    vs = Grid(gr.nr, gr.nc)
    q = deque([(st.pos, 0)])

    while len(q) > 0:
        pos,dist = q.popleft()
        if vs.get(pos.x, pos.y) == 0:
            vs.set(pos.x, pos.y, 1)
            c = gr.get(pos.x, pos.y)
            if is_key(c) and c not in st.keys:
                ds[c] = dist
            for dr in range(4):
                p,c = move(gr, pos, dr)
                if c == ord('#') or (is_door(c) and key_for_door(c) not in st.keys):
                    continue
                q.append((p,dist+1))
    return ds

def get_key(code: int, dist: int, pos: Point, s: State) -> State:
    return State(pos=pos,
            total_dist=s.total_dist + dist,
            keys=s.keys | frozenset([code]),
            path=s.path + chr(code),
            )

def part_one(dstr: str) -> int:
    gr,loc = read_data(dstr)
    all_keys = frozenset(s for s in loc.keys() if is_key(s))
    nkeys = len(all_keys)

    s = State(pos=loc[ord('@')], total_dist=0, keys=frozenset(), path="")
    q = [s]
    for depth in range(nkeys):
        print("GEN", depth, "QLEN", len(q))

        # organize the queue -- if two candidates have same keys and same position,
        # keep only the one with the shortest total_path
        moves: Dict[Tuple[FrozenSet[int],Point],State] = {}
        for s in q:
            k = (s.keys,s.pos)
            if k not in moves:
                moves[k] = s
            else:
                if s.total_dist < moves[k].total_dist:
                    moves[k] = s

        q = []
        for s in moves.values():
            dists = dist_to_keys_from(gr, s)

            # pursue each move until we have all keys
            for key in dists.keys():
                s2 = get_key(key, dists[key], loc[key], s)
                q.append(s2)

    assert all(len(s.keys) == nkeys for s in q)
    #print(list(sorted((s.total_dist,"{0.x},{0.y}".format(s.pos)) for s in q)))
    ms = min(q, key=lambda s: s.total_dist)
    print("PATH", ms.path)
    return ms.total_dist

test1 = """#########
#b.A.@.a#
#########"""

t1ans = part_one(test1)
assert t1ans == 8
print("TEST1:", t1ans)

test2 = """########################
#f.D.E.e.C.b.A.@.a.B.c.#
######################.#
#d.....................#
########################"""

t2ans = part_one(test2)
assert t2ans == 86
print("TEST2:", t2ans)

test3 = """########################
#...............b.C.D.f#
#.######################
#.....@.a.B.c.d.A.e.F.g#
########################
"""

t3ans = part_one(test3)
assert t3ans == 132
print("TEST3:", t3ans)

test4 = """#################
#i.G..c...e..H.p#
########.########
#j.A..b...f..D.o#
########@########
#k.E..a...g..B.n#
########.########
#l.F..d...h..C.m#
#################"""

t4ans = part_one(test4)
assert t4ans == 136
print("TEST4:", t4ans)

test5 = """########################
#@..............ac.GI.b#
###d#e#f################
###A#B#C################
###g#h#i################
########################"""

t5ans = part_one(test5)
assert t5ans == 81
print("TEST5:", t5ans)

def main() -> None:
    inp = open("input.txt").read().strip()
    ans1 = part_one(inp)
    print(ans1)

main()


