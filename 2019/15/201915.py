from typing import List, Tuple, Dict, NamedTuple
from intcode import Intcode
import random

class Point(NamedTuple):
    x: int
    y: int

class Robot:
    UNK = "."
    EMPTY = " "
    WALL = "#"
    OXY = "O"
    ROBOT = "@"

    def __init__(self, prog: List[int]):
        self.field: Dict[Point,str] = {}
        self.pos = Point(0, 0)
        self.ic = Intcode(prog)
        self.dir = 1
        self.upper_left = Point(0,0)
        self.lower_right = Point(0,0)

    def next_position(self, p: Point, dr: int) -> Point:
        nx = p.x
        ny = p.y
        if dr == 1:
            ny = p.y - 1
        elif dr == 2:
            ny = p.y + 1
        elif dr == 3:
            nx = p.x - 1
        else:
            nx = p.x + 1
        return Point(nx, ny)

    def update_dir(self):
        self.dir += random.randint(1,4)

    def update_pos(self, p: Point) -> None:
        self.field[self.pos] = Robot.EMPTY
        self.pos = p
        self.field[self.pos] = Robot.ROBOT
        self.upper_left = Point(min(p.x, self.upper_left.x), min(p.y, self.upper_left.y))
        self.lower_right = Point(max(p.x, self.upper_left.x), max(p.y, self.upper_left.y))

    def print_field(self) -> None:
        for y in range(self.upper_left.y, self.lower_right.y+1):
            for x in range(self.upper_left.x, self.lower_right.x+1):
                print(self.field.get(Point(x,y),Robot.UNK), sep="", end="")

    def run(self) -> None:
        while True:
            #self.print_field()
            ev = self.ic.step()
            print("EV", ev)
            if ev == 99:
                break
            elif ev == 3:
                print("INPUT", self.dir)
                self.ic.input.append(self.dir)
            elif ev == 4:
                assert len(self.ic.output) == 1
                result = self.ic.output.pop(0)
                print("OUTPUT", result)
                nxt = self.next_position(self.pos, self.dir)
                if result == 0:
                    self.field[nxt] = Robot.WALL
                    self.update_dir()
                elif result == 1:
                    self.update_pos(nxt)
                    self.field[nxt] = Robot.EMPTY
                elif result == 2:
                    self.update_pos(nxt)
                    self.field[nxt] = Robot.OXY

def main() -> None:
    prog = [int(s) for s in open("input.txt").read().strip().split(",")]
    robot = Robot(prog)
    robot.run()

main()

