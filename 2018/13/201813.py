from typing import List
from dataclasses import dataclass

DIRS = b'^>v<'

@dataclass
class Point:
    x: int
    y: int

@dataclass
class Cart:
    dr: int
    loc: Point
    state: int = -1

def read_data(instr: str) -> List[bytearray]:
    return [ bytearray(line.rstrip(), 'utf-8')
        for line in instr.splitlines()]

def locate_carts(track: List[bytearray]) -> List[Cart]:
    carts: List[Cart] = []
    for y,row in enumerate(track):
        for x,c in enumerate(row):
            dr = DIRS.find(c)
            if dr >= 0:
                carts.append(Cart(dr, Point(x, y)))
    return carts

def run(instr: str) -> Point:
    pass

ins = open("tinput.txt").read()
d = read_data(ins)
print(d)
cs = locate_carts(d)
print(cs)
assert cs == [Cart(dr=1, loc=Point(2, 0), state=-1), Cart(dr=2, loc=Point(9, 3), state=-1)]

