from intcode import Intcode
from typing import Dict, NamedTuple, List, Iterator, MutableMapping, Set
#from collections.abc import MutableMapping
from io import StringIO

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

    def turn_to_path(self) -> None:
        lft = self.next_step(self.loc, self.left_of(self.dir))
        if self.m[lft] == '#':
            self.dir = self.left_of(self.dir)
        rgt = self.next_step(self.loc, self.right_of(self.dir))
        if self.m[rgt] == '#':
            self.dir = self.right_of(self.dir)

    def find_crosses(self) -> Set[Point]:
        cross: Set[Point] = set()
        self.turn_to_path()
        while self.step_along_path():
            if self.at_crossroads():
                cross.add(self.loc)
            nxs = self.next_step(self.loc, self.dir)
            if self.m[nxs] != '#':
                self.turn_to_path()
        return cross

def part_one(prog: List[int]) -> int:
    r = Robot(prog)
    r.read_map()
    #r.print_map()
    cr = r.find_crosses()
    #print(cr)
    return sum(p.x * p.y for p in cr)

def main() -> None:
    prog = [int(s) for s in open("input.txt").read().strip().split(",")]
    ans1 = part_one(prog)
    print("Part 1:", ans1)

main()

