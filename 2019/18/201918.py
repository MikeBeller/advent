from typing import Dict, NamedTuple, List, Set, Tuple

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

all_keys = set('abcdefghijklmnopqrstuvwxyz')
all_doors = set('ABCDEFGHIJKLMNOPQRSTUVWXYZ')

def dist_to_stuff_from(gr: Dict[Point,Node], st: Point, keys: Dict[str,bool], doors: Dict[str,bool]) -> Dict[str,int]:
    ds: Dict[str,int] = {}
    vs: Dict[Node,bool] = {}

    def bfs(nd: Node, depth: int) -> None:
        if nd in vs:  # stop because you already visited this node
            return
        vs[nd] = True
        if nd.mark in doors and not doors[nd.mark]:
            ds[nd.mark] = depth
            return  # stop this path because you hit a closed door
        if nd.mark in keys and not keys[nd.mark]:
            ds[nd.mark] = depth
        for cn in nd.conns:
            bfs(cn, depth+1)

    bfs(gr[st], 0)
    return ds

def part_one(dstr: str) -> int:
    gr,loc = read_data(dstr)
    print(gr)
    print(loc)

    # one entry per key on the map, true only if you have the key
    keys = dict((k,False) for k in loc.keys() if k in "abcdefghijklmnopqrstuvwxyz")
    # one entry per door on the map, true only if door is unlocked
    doors = dict((d,False) for d in loc.keys() if d in "ABCDEFGHIJKLMNOPQRSTUVWXYZ")

    total_dist = 0
    pos = loc['@']
    while not all(keys.values()):  # while you don't have all keys
        ds = dist_to_stuff_from(gr, pos, keys, doors)
        candidates: List[Tuple[str,int]] = []
        for name,dist in ds.items():
            if name in keys:
                if not keys[name]: # don't have the key yet
                    candidates.append((name,dist))
            if name in doors:
                if not doors[name] and keys[name.lower()]:
                    candidates.append((name,dist))
        best_name,best_dist = min(candidates, key=lambda p: p[1])
        print("CANDIDATES", candidates, "BEST", best_name, best_dist)
        pos = loc[best_name]
        total_dist += best_dist
        if best_name in doors:
            assert best_name.lower() in keys
            doors[best_name] = True  # unlock the door
        elif best_name in keys:
            keys[best_name] = True
        else:
            assert False, "WTF?"
    print("TOTAL DIST", total_dist)
    return total_dist

test1 = """#########
#b.A.@.a#
#########"""

assert part_one(test1) == 8

test2 = """########################
#f.D.E.e.C.b.A.@.a.B.c.#
######################.#
#d.....................#
########################"""

print(part_one(test2))


