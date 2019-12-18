from typing import List, Tuple, Dict, NamedTuple
from intcode import Intcode

class Point(NamedTuple):
    x: int
    y: int

class Robot:
    def __init__(self, prog: List[int]):
        self.field: Dict[Point,str] = {}
        self.pos = Point(0, 0)
        self.ic = Intcode(prog)
        self.dir = 1
        self.upper_left = Point(0,0)
        self.lower_right = Point(0,0)

    def update_dir(x: int, y: int, dr: int) -> Tuple[int,int]:
        nx = x
        ny = y
        if dr == 1:
            ny = y - 1
        elif dr == 2:
            ny = y + 1
        elif dr == 3:
            nx = x - 1
        else:
            nx = x + 1
        return nx, ny

    def run(self):
        while True:
            ev = self.ic.step()
            if ev == 99:
                break
            elif ev == 3:
                self.update_dir()





def main() -> None:
    prog = [int(s) for s in open("input.txt").read().strip().split(",")]
    robot = Robot(prog)
    robot.run()

main()

