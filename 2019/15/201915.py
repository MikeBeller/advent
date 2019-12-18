import os
import pickle
from typing import List, Tuple, Dict, NamedTuple, Deque
from intcode import Intcode
import random
from collections import deque

class Point(NamedTuple):
    x: int
    y: int

class Robot:
    ORIGIN = "X"
    UNK = "?"
    EMPTY = "."
    WALL = "#"
    OXY = "O"
    ROBOT = "@"

    def __init__(self, prog: List[int]):
        self.field: Dict[Point,str] = {Point(0,0): Robot.ROBOT}
        self.pos = Point(0, 0)
        self.ic = Intcode(prog)
        self.dir = 1
        self.upper_left = Point(0,0)
        self.lower_right = Point(0,0)
        self.oxy_position = Point(9999,9999)
        self.oxy_known = False
        self.num_steps = 0

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

    def outside_field(self, p: Point) -> bool:
        min_x,min_y = self.upper_left
        max_x,max_y = self.lower_right
        return p.x < min_x or p.x > max_x or p.y < min_y or p.y > max_y

    def reachable(self, p: Point) -> bool:
        for dr in range(1,5):
            nxt = self.next_position(p, dr)
            if not self.outside_field(nxt) and self.field.get(nxt,Robot.UNK) != Robot.WALL:
                return True
        return False

    def all_unknown_unreachable(self) -> bool:
        for y in range(self.upper_left.y, self.lower_right.y + 1):
            for x in range(self.upper_left.x, self.lower_right.x + 1):
                p = Point(x,y)
                if p not in self.field and self.reachable(Point(x,y)):
                    return False
        return True

    def update_dir(self) -> None:
        # random
        #self.dir = (self.dir - 1 + random.randint(1,4)) % 4 + 1
        # random not towards wall
        possible = [d for d in range(1,5)
            if self.field.get(self.next_position(self.pos, d),Robot.EMPTY)
            != Robot.WALL]
        self.dir = random.choice(possible)

    def update_pos(self, p: Point) -> None:
        self.pos = p

    def include_in_field(self, p: Point) -> None:
        self.upper_left = Point(min(p.x, self.upper_left.x), min(p.y, self.upper_left.y))
        self.lower_right = Point(max(p.x, self.lower_right.x), max(p.y, self.lower_right.y))

    def print_field(self) -> None:
        for y in range(self.upper_left.y, self.lower_right.y+1):
            for x in range(self.upper_left.x, self.lower_right.x+1):
                if x == self.pos.x and y == self.pos.y:
                    print(Robot.ROBOT, sep="", end="")
                elif x == 0 and y == 0:
                    print(Robot.ORIGIN, sep="", end="")
                else:
                    print(self.field.get(Point(x,y),Robot.UNK), sep="", end="")
            print()
        print()

    def explore_maze(self) -> None:
        self.num_steps = 0
        while True:
            ev = self.ic.step()
            if ev == 99:
                break
            elif ev == 3:
                self.ic.input.append(self.dir)
            elif ev == 4:
                assert len(self.ic.output) == 1
                result = self.ic.output.pop(0)
                nxt = self.next_position(self.pos, self.dir)
                self.include_in_field(nxt)
                if result == 0:
                    self.field[nxt] = Robot.WALL
                    self.update_dir()
                elif result == 1:
                    self.update_pos(nxt)
                    self.field[nxt] = Robot.EMPTY
                    self.update_dir()
                elif result == 2:
                    self.update_pos(nxt)
                    self.field[nxt] = Robot.OXY
                    self.oxy_position = nxt
                    self.oxy_known = True
                    self.update_dir()
                self.num_steps += 1
                if self.num_steps % 10000 == 0:
                    os.system("clear")
                    self.print_field()
                    if self.oxy_known and self.all_unknown_unreachable():
                        print(self.num_steps)
                        break

    def shortest_path(self, start: Point, end: Point) -> int:
        dst: Dict[Point,int] = {start: 0}
        q: Deque[Point] = deque([start])
        while len(q) != 0:
            v = q.popleft()
            if v == end:
                return dst[v]
            for dr in range(1,5):
                nxt = self.next_position(v, dr)
                if self.field.get(nxt, Robot.UNK) != Robot.WALL:
                    if nxt not in dst:
                        dst[nxt] = dst[v] + 1
                        q.append(nxt)
        assert False, "WTF?"

    def fill_oxy(self, start: Point) -> int:
        dst: Dict[Point,int] = {}
        for pos,v in self.field.items():
            if v in [Robot.EMPTY, Robot.OXY, Robot.ROBOT, Robot.ORIGIN]:
                dst[pos] = -1
        dst[start] = 0
        q: Deque[Point] = deque([start])
        count = 1
        while len(q) != 0:
            p = q.popleft()
            for dr in range(1,5):
                nxt = self.next_position(p, dr)
                if nxt in dst and dst[nxt] == -1:
                    dst[nxt] = dst[p] + 1
                    q.append(nxt)
        return max(dst.values())

def main() -> None:
    prog = [int(s) for s in open("input.txt").read().strip().split(",")]
    robot = Robot(prog)
    robot.explore_maze()
    #with open("robot.pck","wb") as outf:
    #    pickle.dump(robot, outf)
    #robot = pickle.load(open("robot.pck","rb"))

    start = Point(0,0)
    oxy = robot.oxy_position
    ans1 = robot.shortest_path(start, oxy)
    print("Part 1:", ans1)

    ans2 = robot.fill_oxy(oxy)
    print("Part 2:", ans2)


main()

