from typing import List, Union, Tuple, Optional, Iterator, Any, cast
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
    assert isinstance(ln, int) and isinstance(rn, int)
    r = n.copy()
    j = index_of_first_number_before(n, i)
    if j is not None:
        r[j] = cast(int, r[j]) + ln
    k = index_of_first_number_after(n, i+2)
    if k is not None:
        r[k] = cast(int, r[k]) + rn
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
            p: SFNum = ['[', int(floor(v / 2)), int(ceil(v / 2)), ']']
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
    return cast(SFNum, ['[']) + a + b + cast(SFNum, [']'])


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


def tree_r(it: Iterator[Union[str, int]]) -> Union[int, List[Any]]:
    d = next(it)
    if isinstance(d, int):
        return d
    assert d == '['
    a = tree_r(it)
    b = tree_r(it)
    assert next(it) == ']'
    return [a, b]


def tree(num: SFNum) -> List[Any]:
    return cast(SFNum, tree_r(iter(num)))


def tree_magnitude(t: List[Any]) -> int:
    if isinstance(t, int):
        return t
    else:
        assert isinstance(t, list) and len(t) == 2
        lt, rt = t
        a = tree_magnitude(lt)
        b = tree_magnitude(rt)
        return 3 * a + 2 * b


def magnitude(n: SFNum) -> int:
    t = tree(n)
    m = tree_magnitude(t)
    return m


assert magnitude(parse("[[1,2],[[3,4],5]]")) == 143

assert magnitude(
    parse("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")) == 3488

ls3 = sflist("""
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
""".strip().splitlines())

sm3 = sum(ls3)
assert pr(
    sm3) == "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]"
assert magnitude(sm3) == 4140

data = sflist(open("input.txt").read().splitlines())


def part1(data: List[SFNum]) -> int:
    return magnitude(sum(data))


print("PART1:", part1(data))


def part2(data: List[SFNum]) -> int:
    return max(
        max(magnitude(sum([data[i], data[j]])),
            magnitude(sum([data[j], data[i]])))
        for i in range(len(data)-1)
        for j in range(i+1, len(data))
    )


assert part2(ls3) == 3993
print("PART2:", part2(data))
