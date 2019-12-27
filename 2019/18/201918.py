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

def dist_to_stuff_from(gr: Dict[Point,Node], s: State) -> Dict[str,int]:
    ds: Dict[str,int] = {}
    vs: Dict[Node,bool] = {}

    def bfs(nd: Node, depth: int) -> None:
        if nd in vs:  # stop because you already visited this node
            return
        vs[nd] = True
        if is_door(nd.mark) and nd.mark.lower() not in s.keys:
            return  # stop this path because you hit a closed door
        if is_key(nd.mark) and nd.mark not in s.keys:
            ds[nd.mark] = depth
        for cn in nd.conns:
            bfs(cn, depth+1)

    bfs(gr[s.pos], 0)
    return ds

def find_candidates(dists: Dict[str,int], s: State) -> List[str]:
    return [k for k in dists.keys() if k not in s.keys]

def get_key(name: str, dist: int, pos: Point, s: State) -> State:
    return State(pos=pos,
            total_dist=s.total_dist + dist,
            keys=s.keys | frozenset(name))

def part_one(dstr: str) -> int:
    gr,loc = read_data(dstr)
    all_keys = frozenset(s for s in loc.keys() if is_key(s))

    s = State(pos=loc['@'], total_dist=0, keys=frozenset())
    q = deque([s])
    min_dist = 9999999999
    count = 0
    while q:
        # find candidate moves
        s = q.popleft()
        dists = dist_to_stuff_from(gr, s)
        keys = find_candidates(dists, s)

        keys.sort(key=lambda n: dists[n])  # sort ascending by distance to favor close choices

        # pursue each move until we have all keys
        for key in keys:
            s2 = get_key(key, dists[key], loc[key], s)
            if s2.keys == all_keys:
                if s2.total_dist < min_dist:
                    min_dist = s2.total_dist
            else:
                #q.append(s2)      #BFS
                q.appendleft(s2)  #DFS

        count += 1
        if count > 10000000: break

    print("MIN:", min_dist)
    return min_dist

test1 = """#########
#b.A.@.a#
#########"""

assert part_one(test1) == 8

test2 = """########################
#f.D.E.e.C.b.A.@.a.B.c.#
######################.#
#d.....................#
########################"""

assert part_one(test2) == 86

test3 = """#################
#i.G..c...e..H.p#
########.########
#j.A..b...f..D.o#
########@########
#k.E..a...g..B.n#
########.########
#l.F..d...h..C.m#
#################"""

#print("TEST3:", part_one(test3))

test4 = """########################
#@..............ac.GI.b#
###d#e#f################
###A#B#C################
###g#h#i################
########################"""

assert part_one(test4) == 81

def main() -> None:
    inp = open("input.txt").read().strip()
    ans1 = part_one(inp)
    print(ans1)

#main()


