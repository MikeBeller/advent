from intcode import Intcode
from typing import Dict, NamedTuple, List, Iterator, MutableMapping, Set, Tuple, Union, DefaultDict
from collections import defaultdict
from io import StringIO
import itertools

class Point(NamedTuple):
    x: int
    y: int

class Map(MutableMapping[Point,str]):
    def __init__(self) -> None:
        self.m: Dict[Point,str] = {}
        self.height = 0
        self.width = 0

    def __getitem__(self, k: Point) -> str:
        return self.m.get(k, '.')

    def __setitem__(self, k: Point, v: str) -> None:
        if k.x+1 > self.width:
            self.width = k.x+1
        if k.y+1 > self.height:
            self.height = k.y+1
        if v != '.':
            self.m[k] = v

    def __delitem__(self, k: Point) -> None:
        del self.m[k]

    def __iter__(self) -> Iterator[Point]:
        return iter(self.m)

    def __len__(self) -> int:
        return len(self.m)

class Robot:
    robot_dirs = {'^': 0, '>': 1, 'v': 2, '<': 3, 'X': -1}
    robot_chars = {-1: 'X', 0: '^', 1: '>', 2: 'v', 3: '<'}

    def __init__(self, prog: List[int]) -> None:
        self.ic = Intcode(prog)
        self.m = Map()
        self.loc = Point(-1, -1)
        self.dir = 0

    def read_map(self) -> None:
        self.ic.run()
        x = 0
        y = 0
        for cc in self.ic.output:
            if cc == 10:
                y += 1
                x = 0
            else:
                c = chr(cc)
                loc = Point(x,y)
                if c in self.robot_dirs:
                    self.loc = loc
                    self.dir = self.robot_dirs[c]
                    if self.dir != -1:
                        self.m[loc] = '#'
                else:
                    self.m[loc] = c
                x += 1

    def print_map(self) -> None:
        for y in range(self.m.height):
            for x in range(self.m.width):
                loc = Point(x,y)
                c = self.m.get(loc, '.')
                if loc == self.loc:
                    c = self.robot_chars[self.dir]
                print(c, sep="", end="")
            print(sep="")

    def next_step(self, p: Point, dr: int) -> Point:
        nx = p.x
        ny = p.y
        if dr == 0:
            ny = p.y - 1
        elif dr == 1:
            nx = p.x + 1
        elif dr == 2:
            ny = p.y + 1
        elif dr == 3:
            nx = p.x - 1
        else:
            assert False, "Tried to move in invalid direction"
        return Point(nx, ny)

    def step_along_path(self) -> bool:
        nxs = self.next_step(self.loc, self.dir)
        if self.m[nxs] != '#':
            return False
        self.loc = nxs
        return True

    def left_of(self, dr: int) -> int:
        assert dr != -1
        return (dr - 1) % 4

    def right_of(self, dr: int) -> int:
        assert dr != -1
        return (dr + 1) % 4

    def at_crossroads(self) -> bool:
        nxs = self.next_step(self.loc, self.dir)
        if self.m[nxs] != '#':
            return False
        lft = self.next_step(self.loc, self.left_of(self.dir))
        rgt = self.next_step(self.loc, self.right_of(self.dir))
        if self.m[lft] == '#' and self.m[rgt] == '#':
            return True
        return False

    def turn_to_path(self) -> str:
        lft = self.next_step(self.loc, self.left_of(self.dir))
        if self.m[lft] == '#':
            self.dir = self.left_of(self.dir)
            return "L"
        rgt = self.next_step(self.loc, self.right_of(self.dir))
        if self.m[rgt] == '#':
            self.dir = self.right_of(self.dir)
            return "R"
        return ""

    def trace_path(self) -> Tuple[List[str],Set[Point]]:
        cross: Set[Point] = set()
        path: List[str] = []
        dr = self.turn_to_path()
        if dr != "":
            path.append(dr)
        while self.step_along_path():
            path.append('F')
            if self.at_crossroads():
                cross.add(self.loc)
            nxs = self.next_step(self.loc, self.dir)
            if self.m[nxs] != '#':
                dr = self.turn_to_path()
                path.append(dr)
        return path, cross

def part_one(prog: List[int]) -> int:
    r = Robot(prog)
    r.read_map()
    _,cr = r.trace_path()
    return sum(p.x * p.y for p in cr)

def simplify_path(path: List[str]) -> bytes:
    p = bytearray()
    in_run = False
    ln = 0
    for c in path:
        if c == 'L' or c == 'R':
            if in_run:
                p.append(ln)
                ln = 0
                in_run = False
            p.append(254 if c == 'L' else 255)
        elif c == 'F':
            if in_run:
                ln += 1
            else:
                in_run = True
                ln = 1
    if in_run:
        p.append(ln)
    return memoryview(bytes(p))

def pathstr(ps: bytes) -> str:
    pp: List[str] = []
    for b in ps:
        if b == 254:
            pp.append('L')
        elif b == 255:
            pp.append('R')
        else:
            pp.append(str(b))
    return ",".join(pp)

def psplit(ps: List[str], d: str, nm: str) -> List[str]:
    p2: List[str] = []
    for p in ps:
        rest = p
        while d in rest:
            l,rest = rest.split(d,1)
            p2.append(l)
            p2.append(nm)
        if rest:
            p2.append(rest)

    return [s for s in p2 if s not in [',',', ', ' ,']]
            
def print_best_substrings(ps: bytes) -> None:
    # brute force substrings:
    mn = 5
    mx = 20
    subs: DefaultDict[bytes,int] = defaultdict(int)
    for i in range(len(ps) - mn):
        for j in range(i+mn, min(i+mx, len(ps))):
                subs[ps[i:j]] += 1

    ssubs = list(sorted(subs.items(), key=lambda t: t[1]*len(t[0])))
    ssubs = list(sorted(subs.items(), key=lambda t: t[1]))
    for p,c in ssubs[-10:]:
        print(c, len(p), pathstr(p))
    print(len(ps))

def part_two(prog: List[int]) -> int:
    r = Robot(prog)
    r.read_map()
    #r.print_map()
    path,cr = r.trace_path()
    ps = simplify_path(path)

    # Use this to eyeball some candidate substrings
    print_best_substrings(ps)

    # Take a look at the path break down into programs
    pps = pathstr(ps)
    print(pps)
    progs = {'A': "L,10,L,12,R,6", 'B': "L,10,R,10,R,6,L,4", 'C': "R,10,L,4,L,4,L,12"}
    print(progs)
    ss = [pps]
    for k,v in progs.items():
        ss = psplit(ss, v, k)
    print(ss)

    # Convert the program to the format required by the robot
    inp = bytearray()
    inp.extend(bytearray(",".join(ss), 'utf-8'))
    inp.append(10)
    for k in "ABC":
        pr = progs[k]
        inp.extend(bytearray(pr, 'utf-8'))
        inp.append(10)
    inp.append(ord('n'))
    inp.append(10)
    print(inp)

    # Run the robot with this input
    assert prog[0] == 1
    prog[0] = 2
    ic = Intcode(prog, inp)
    ic.run()
    ans = ic.output.pop()
    print(str(bytes(ic.output),'utf-8'))

    return ans

def main() -> None:
    prog = [int(s) for s in open("input.txt").read().strip().split(",")]
    ans1 = part_one(prog)
    print("Part 1:", ans1)

    ans2 = part_two(prog)
    print("part 2:", ans2)

main()

