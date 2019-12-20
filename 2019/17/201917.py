from intcode import Intcode
from typing import Dict, NamedTuple, List, Iterator, MutableMapping
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


def char_to_dir(c: str) -> int:
    return {'^': 0, '>': 1, 'v': 2, '<': 3}[c]

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
                print(self.m.get(Point(x,y),'.'), sep="", end="")
            print(sep="")

    def follow_path(self) -> None:
        pass


def main() -> None:
    prog = [int(s) for s in open("input.txt").read().strip().split(",")]
    r = Robot(prog)
    r.read_map()
    r.print_map()

main()

