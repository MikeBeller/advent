from typing import Dict, NamedTuple, List, FrozenSet, Set, Tuple, Deque, Any
import numpy as np
from nptyping import NDArray
from collections import deque
from numba import jit
from numba.typed import Dict as NumbaDict

class Point(NamedTuple):
    x: int
    y: int

Grid = NDArray[(Any,Any), np.int8]

@jit(nopython=True)
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
    nr,nc = gr.shape
    if p.x < 0 or p.x >= nc or p.y < 0 or p.y >= nr:
        return p, ord('#')
    else:
        return p, gr[p.y, p.x]

def read_data(s: str) -> Tuple[Grid, Dict[int,Point]]:
    s = s.replace(' ','')
    lines = s.splitlines()
    nr = len(lines)
    nc = len(lines[0])
    gr = np.zeros((nr,nc), dtype=np.int8)
    loc: Dict[int,Point] = {}

    for y,line in enumerate(lines):
        for x,c in enumerate(line):
            gr[y, x] = ord(c)
            if c != '.':
                loc[ord(c)] = Point(x,y)

    return gr, loc

@jit(nopython=True)
def key_num(c: int) -> int:
    return c - ord('a') if c >= ord('a') and c <= ord('z') else -1

@jit(nopython=True)
def key_code_from_key_num(c: int) -> int:
    return c + ord('a')

@jit(nopython=True)
def door_num(c: int) -> bool:
    return c - ord('A') if c >= ord('A') and c <= ord('Z') else -1

class State(NamedTuple):
    pos: Point
    total_dist: int
    keys: NDArray[(Any,), np.int8]
    path: str

@jit(nopython=True)
def dist_to_keys_from(gr: Grid, st: State) -> NDArray[(Any,), int]:
    nr,nc = gr.shape
    nkeys = len(st.keys)
    ds = np.full(nkeys, -1, dtype=np.int32)
    vs = np.zeros((nr, nc), dtype=np.int8)
    q = [(st.pos, 0)]
    i = 0

    while i < len(q):
        pos,dist = q[i]
        i += 1
        if vs[pos.y, pos.x] == 0:
            vs[pos.y, pos.x] = 1
            c = gr[pos.y, pos.x]
            nk = key_num(c)
            if nk != -1 and st.keys[nk] == 0:
                ds[nk] = dist
            for dr in range(4):
                p,c = move(gr, pos, dr)
                if c == ord('#'):
                    continue
                nd = door_num(c)
                if nd != -1 and st.keys[nd] == 0:
                    if st.keys[nd] == 0:
                        continue
                q.append((p,dist+1))
    return ds

def get_key(key_num: int, dist: int, pos: Point, s: State) -> State:
    kk = s.keys.copy()
    kk[key_num] = 1
    code = key_code_from_key_num(key_num)
    return State(pos=pos,
            total_dist=s.total_dist + dist,
            keys=kk,
            path=s.path + chr(code),
            )

def part_one(dstr: str) -> int:
    gr,loc = read_data(dstr)
    all_keys = frozenset(s for s in loc.keys() if key_num(s) != -1)
    nkeys = len(all_keys)
    # just make sure that all keys are named like abcde.. with no gaps
    assert "".join(sorted(chr(k) for k in all_keys)) == "abcdefghijklmnopqrstuvwxyz"[:nkeys]

    s = State(pos=loc[ord('@')], total_dist=0,
            keys=np.zeros(nkeys, dtype=np.int8), path="")
    q = [s]
    for depth in range(nkeys):
        print("GEN", depth, "QLEN", len(q))

        # organize the queue -- if two candidates have same keys and same position,
        # keep only the one with the shortest total_path
        moves: Dict[Tuple[bytes,Point],State] = {}
        for s in q:
            keys = s.keys.tobytes()
            k = (keys,s.pos)
            if k not in moves:
                moves[k] = s
            else:
                if s.total_dist < moves[k].total_dist:
                    moves[k] = s

        q = []
        for s in moves.values():
            dists = dist_to_keys_from(gr, s)

            # pursue each move until we have all keys
            for (nk,d) in enumerate(dists):
                if d == -1: continue
                key = key_code_from_key_num(nk)
                s2 = get_key(nk, d, loc[key], s)
                q.append(s2)

    assert all(len(s.keys) == nkeys for s in q)
    ms = min(q, key=lambda s: s.total_dist)
    print("PATH", ms.path)
    return ms.total_dist

def tests():
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

#tests()
main()

