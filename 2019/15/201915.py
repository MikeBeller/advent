from typing import List, Tuple, Iterator
from curses import wrapper
from intcode import Intcode

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

def show(scr, prog: List[int]) -> int:
    direction = 1
    def thunk() -> Iterator[int]:
        while True:
            yield direction

    ic = Intcode(prog, thunk())
    x = 20
    y = 20
    while True:
        scr.addstr(x, y, "@")
        op = ic.run_to_event()
        if op == 99:
            break
        elif op == 4:
            nx,ny = update_dir(x, y, direction)
            out = ic.output.pop(0)
            if out == 0:
                scr.addstr(nx, ny, "#")
                direction = ((direction-1) + 1) % 4 + 1
            elif out == 1:
                scr.addstr(nx, ny, '.')
                x = nx; y = ny
            else:
                scr.addstr(nx, ny, 'x')
                x = nx; y = ny





def main() -> None:
    prog = [int(s) for s in open("input.txt").read().strip().split(",")]
    wrapper(show, prog)


main()

