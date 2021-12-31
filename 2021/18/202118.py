from typing import List, Union, Tuple
from math import floor, ceil

SFNum = List[Union[str, int]]


def parse(instr):
    r = []
    for c in instr:
        if c in ['[', ']']:
            r.append(c)
        elif c.isdigit():
            r.append(int(c))
    return r


ex1 = parse('[[[[[9,8],1],2],3],4]')
print(ex1)


def split(n):
    return True, n


def explode_this(n, i):
    return n


def explode(n):
    d = 0
    for i, v in range(len(n)):
        if v == '[':
            d += 1
        elif v == ']':
            d -= 1
        else:
            if d == 4:
                return True, explode_this(n, i)
    return False, n


def reduce(n):
    while True:
        is_exploded, n = explode(n)
        if exploded:
            continue
        is_split, n = split(n)
        if is_split:
            continue
        break
    return n


print(reduce(ex1))
