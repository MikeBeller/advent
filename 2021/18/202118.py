from typing import List, Union, Tuple, Optional
from math import floor, ceil

SFNum = List[Union[str, int]]


def parse(instr: str) -> SFNum:
    r: SFNum = []
    for c in instr:
        if c in ['[', ']']:
            r.append(c)
        elif c.isdigit():
            r.append(int(c))
    #print("PARSE:", instr, r)
    return r


assert parse('[[[[[9,8],1],2],3],4]') == [
    '[', '[', '[', '[', '[', 9, 8, ']', 1, ']', 2, ']', 3, ']', 4, ']']


def pr(n: SFNum) -> str:
    s = ",".join(str(v) for v in n)
    s = s.replace("[,", "[")
    s = s.replace(",]", "]")
    #print("PR", n, s)
    return s


assert pr(parse('[[[[[9,8],1],2],3],4]')) == '[[[[[9,8],1],2],3],4]'


def split(n: SFNum) -> Tuple[bool, SFNum]:
    return False, n


def index_of_first_number_before(n: SFNum, i: int) -> Optional[int]:
    for j in range(i-1, -1, -1):
        if isinstance(n[j], int):
            return j
    return None


def index_of_first_number_after(n: SFNum, i: int) -> Optional[int]:
    for j in range(i, len(n)):
        if isinstance(n[j], int):
            return j
    return None


def explode_this(n: SFNum, i: int) -> SFNum:
    ln, rn = n[i:i+2]
    r = n.copy()
    j = index_of_first_number_before(n, i)
    if j is not None:
        r[j] += ln
    k = index_of_first_number_after(n, i+2)
    if k is not None:
        r[k] += rn
    assert r[i-1] == '['
    assert r[i+2] == ']'
    return r[0:i-1] + [0] + r[i+3:]


def explode(n: SFNum) -> Tuple[bool, SFNum]:
    d = 0
    for i, v in enumerate(n):
        if v == '[':
            d += 1
        elif v == ']':
            d -= 1
        else:
            if d == 5 and isinstance(n[i+1], int):
                return True, explode_this(n, i)
    return False, n


def split(n: SFNum) -> Tuple[bool, SFNum]:
    for i, v in enumerate(n):
        if isinstance(v, int) and v > 9:
            p = ['[', floor(v / 2), ceil(v / 2), ']']
            return True, n[:i] + p + n[i+1:]
    return False, n


def reduce(n: SFNum) -> SFNum:
    while True:
        # print(pr(n))
        is_exploded, n = explode(n)
        if is_exploded:
            continue
        is_split, n = split(n)
        if is_split:
            continue
        break
    # print(pr(n))
    return n


def test_explode(a: str, is_explode: bool, b: str) -> None:
    tf, r = explode(parse(a))
    assert tf == is_explode, "didn't explode"
    assert pr(r) == b, f"explode didn't match: {a} {b}"


test_explode("[[[[[9,8],1],2],3],4]", True, "[[[[0,9],2],3],4]")
test_explode("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]",
             True, "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")

assert pr(reduce(parse("[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]"))
          ) == "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"


def add(a: SFNum, b: SFNum) -> SFNum:
    return ['['] + a + b + [']']


def sum(ns: List[SFNum]) -> SFNum:
    n = ns[0]
    for v in ns[1:]:
        n = add(n, v)
        n = reduce(n)
    return n


def sflist(sls: List[str]) -> List[SFNum]:
    return [parse(s) for s in sls]


ls1 = sflist("""[1,1]
[2,2]
[3,3]
[4,4]""".splitlines())

assert pr(sum(ls1)) == "[[[[1,1],[2,2]],[3,3]],[4,4]]"

ls2 = sflist("""
[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]
""".strip().splitlines())

assert pr(sum(ls2)) == "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"
