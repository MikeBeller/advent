from typing import List
from dataclasses import dataclass

@dataclass
class Cart:
    dr: int
    x: int
    y: int
    state: int = 0

def read_data(instr: str) -> List[bytearray]:
    return [ bytearray(line.rstrip(), 'utf-8')
        for line in instr.splitlines()]

def locate_carts(track: List[bytearray]) -> List[Cart]:
    carts: List[Cart] = []
    for y,row in enumerate(track):
        for x,c in enumerate(row):
            if c in bytes(b"^>v<"):
                carts.append(Cart(c, x, y))
    return carts

ins = open("tinput.txt").read()
d = read_data(ins)
print(d)
cs = locate_carts(d)
print(cs)
assert cs == [Cart(dr=ord('>'), x=2, y=0, state=0), Cart(dr=ord('v'), x=9, y=3, state=0)]

