from typing import Dict,NamedTuple

class Point(NamedTuple):
    x: int
    y: int

test1 = """#########
#b.A.@.a#
#########"""

test2 = """########################
#f.D.E.e.C.b.A.@.a.B.c.#
######################.#
#d.....................#
########################"""

def read_data(s: str) -> Dict[Point,str]:
    r: Dict[Point,str] = {}
    for y,line in enumerate(s.splitlines()):
        for x,c in enumerate(line.strip()):
            if c != '#':
                r[Point(x,y)] = c
    return r

d = read_data(test1)
print(d)



