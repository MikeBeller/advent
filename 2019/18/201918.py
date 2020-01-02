from typing import Dict, NamedTuple, List, FrozenSet, Set, Tuple, Deque
from collections import deque

class Point(NamedTuple):
    x: int
    y: int

class Node:
    def __init__(self, x: int, y: int, mark: str) -> None:
        self.loc = Point(x, y)
        self.mark = mark
        self.conns: Set[Node] = set()

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

def read_data(s: str) -> Tuple[Dict[Point,Node], Dict[str,Point]]:
    gr: Dict[Point,Node] = {}
    loc: Dict[str,Point] = {}
    for y,line in enumerate(s.splitlines()):
        for x,c in enumerate(line.strip()):
            if c != '#':
                p = Point(x,y)
                gr[p] = Node(x, y, c)
                if c != '.':
                    loc[c] = p

    for p in gr.keys():
        for i in range(4):
            q = move(p, i)
            if q in gr:
                gr[p].conns.add(gr[q])
                gr[q].conns.add(gr[p])
    return gr, loc


key_names = frozenset('abcdefghijklmnopqrstuvwxyz')
door_names = frozenset('ABCDEFGHIJKLMNOPQRSTUVWXYZ')

def is_key(s: str) -> bool:
    return s in key_names

def is_door(s: str) -> bool:
    return s in door_names

class State(NamedTuple):
    pos: Point
    total_dist: int
    keys: FrozenSet[str]
    path: str

def dist_to_keys_from(gr: Dict[Point,Node], st: State) -> Dict[str,int]:
    ds: Dict[str,int] = {}
    vs: Dict[Node,bool] = {}
    q = deque([(gr[st.pos], 0)])

    while len(q) > 0:
        nd,dist = q.popleft()
        if nd not in vs:
            vs[nd] = True
            if is_door(nd.mark) and nd.mark.lower() not in st.keys:
                continue # hit a locked door
            if is_key(nd.mark) and nd.mark not in st.keys:
                ds[nd.mark] = dist
            for cn in nd.conns:
                q.append((cn,dist+1))

    return ds

def get_key(name: str, dist: int, pos: Point, s: State) -> State:
    return State(pos=pos,
            total_dist=s.total_dist + dist,
            keys=s.keys | frozenset(name),
            path=s.path + name,
            )

def part_one(dstr: str) -> int:
    gr,loc = read_data(dstr)
    all_keys = frozenset(s for s in loc.keys() if is_key(s))
    nkeys = len(all_keys)

    s = State(pos=loc['@'], total_dist=0, keys=frozenset(), path="")
    q = [s]
    for depth in range(nkeys):
        print("GEN", depth, "QLEN", len(q))

        # organize the queue -- if two candidates have same keys and same position,
        # keep only the one with the shortest total_path
        moves: Dict[Tuple[FrozenSet[str],Point],State] = {}
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


