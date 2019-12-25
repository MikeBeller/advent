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
    unlocked: FrozenSet[str]
    have_keys: FrozenSet[str]

def dist_to_stuff_from(gr: Dict[Point,Node], s: State) -> Dict[str,int]:
    ds: Dict[str,int] = {}
    vs: Dict[Node,bool] = {}

    def bfs(nd: Node, depth: int) -> None:
        if nd in vs:  # stop because you already visited this node
            return
        vs[nd] = True
        if is_door(nd.mark) and nd.mark not in s.unlocked:
            ds[nd.mark] = depth
            return  # stop this path because you hit a closed door
        if is_key(nd.mark) and nd.mark not in s.have_keys:
            ds[nd.mark] = depth
        for cn in nd.conns:
            bfs(cn, depth+1)

    bfs(gr[s.pos], 0)
    return ds

def part_one(dstr: str) -> int:
    gr,loc = read_data(dstr)
    all_keys = frozenset(s for s in loc.keys() if is_key(s))

    s = State(pos=loc['@'], total_dist=0, unlocked=frozenset(), have_keys=frozenset())
    q = deque([s])
    #paths: List[State] = []
    min_dist = 9999999999
    count = 0
    while q:
        # find candidate moves
        s = q.popleft()
        #print("STATE", s)
        ds = dist_to_stuff_from(gr, s)
        candidates: List[Tuple[str,int]] = []
        for name,dist in ds.items():
            if dist == 0: continue  # skip self
            if is_key(name) and name not in s.have_keys:
                candidates.append((name,dist))
            if is_door(name) and name not in s.unlocked and name.lower() in s.have_keys:
                candidates.append((name,dist))

        candidates.sort(key=lambda p: p[1])  # sort ascending by distance to favor close choices
        #print("CANDIDATES:", candidates)
        # pursue each move until we have all keys
        for name,dist in candidates:
            if is_door(name):
                assert name.lower() in s.have_keys
                #print("OPEN DOOR", name)
                s2 = State(pos=loc[name],
                    total_dist=s.total_dist + dist,
                    unlocked=s.unlocked | frozenset([name]),
                    have_keys=s.have_keys)
                if s2.total_dist < min_dist:
                    #q.append(s2)      #BFS
                    q.appendleft(s2)  #DFS
            elif is_key(name):
                #print("PICK KEY", name)
                s2 = State(pos=loc[name],
                        total_dist=s.total_dist + dist,
                        unlocked=s.unlocked,
                        have_keys=s.have_keys | frozenset(name))
                if s2.have_keys == all_keys:
                    #print("ADDING PATH", s2)
                    #paths.append(s2)
                    if s2.total_dist < min_dist:
                        min_dist = s2.total_dist
                else:
                    if s2.total_dist < min_dist:
                        #q.append(s2)     # BFS
                        q.appendleft(s2)  # DFS
        #print("Q:", q)
        count += 1
        if count > 10000000: break

    #print(len(q))
    #if len(q) > 1:
    #    print(q[-1])
    #ms = min(paths, key=lambda s: s.total_dist)
    print(count)
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

print("TEST2:", part_one(test2))

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

print("TEST4:", part_one(test4))
