import os
from typing import Dict, List
from intcode import Intcode
from collections import namedtuple
from curses import wrapper

Point = namedtuple('Point', ['x','y'])

def part_one(prog: List[int]) -> int:
    grid: Dict[Point,int] = {}

    ic = Intcode(prog, [])
    while True:
        op = ic.run_to_event()
        if op == 99:
            break
        if len(ic.output) >= 3:
            x,y,tid,*ic.output = ic.output
            grid[Point(x,y)] = tid
    print(min(p.x for p in grid.keys()), max(p.x for p in grid.keys()))
    print(min(p.y for p in grid.keys()), max(p.y for p in grid.keys()))
    return sum(1 if v == 2 else 0 for v in grid.values())

def rungame(scr, prog: List[int]) -> int:
    scr.nodelay(True)
    scr.leaveok(True)
    paddle_dir = 0
    def input_thunk():
        while True:
            yield paddle_dir

    ic = Intcode(prog, input_thunk())
    ic.memory[0] = 2
    score = -1
    ball = paddle = Point(-1,-1)
    dx = 0
    game_is_live = False
    while True:
        op = ic.run_to_event()
        if op == 99:
            break
        assert len(ic.output) <= 3
        if len(ic.output) < 3:
            continue
        x,y,tid,*ic.output = ic.output
        if x == -1 and y == 0:
            score = tid
            scr.addstr(0, 0, str(score))
            game_is_live = True
        else:
            #grid[y,x] = tid
            scr.addch(y, x, " #X_@"[tid])
        if tid == 3:
            paddle = Point(x,y)
        elif tid == 4:
            if ball != Point(-1,-1):
                dx = x - ball.x
            ball = Point(x,y)
        if game_is_live:
            # interactive game!
            #c = scr.getch()
            #if c == 260:
            #    paddle_dir = -1
            #elif c == 261:
            #    paddle_dir = 1
            #else:
            #    paddle_dir = 0

            # heuristic which seems to work!
            if ball.x < paddle.x:
                if dx < 0:
                    paddle_dir = -1
                else:
                    paddle_dir = 0
            elif ball.x > paddle.x:
                if dx > 0:
                    paddle_dir = 1
                else:
                    paddle_dir = 0
            else:
                paddle_dir = 0

        #if game_is_live:
        #    time.sleep(0.05)
        scr.refresh()

    return score

def part_two(prog: List[int]):
    return wrapper(rungame, prog)

def main() -> None:
    prog = [int(s) for s in open("input.txt").read().strip().split(",")]
    ans1 = part_one(prog)
    print("Part 1", ans1)

    ans2 = part_two(prog)
    print("Part 2", ans2)

main()

