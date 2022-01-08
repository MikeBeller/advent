from math import floor, ceil
from typing import Optional, List
import copy


class SF:
    def __init__(self, a: Optional['SF'] = None, b: Optional['SF'] = None, n: Optional[int] = None):
        self.a = a
        self.b = b
        self.n = n

    def isnum(self) -> bool:
        return self.n is not None

    def __str__(self):
        if self.isnum():
            return str(self.n)
        else:
            return "[" + str(self.a) + "," + str(self.b) + "]"

    def explode(self) -> bool:
        ln = None
        nn = None
        en = None

        # find last number, exploding node, next number, and whether it explodes
        def explode_r(sf, d=0):
            nonlocal ln, nn, en
            if en is not None:
                if nn is not None:
                    return
                if sf.isnum():
                    nn = sf
                    return
            else:
                if sf.isnum():
                    ln = sf
                    return
                elif d == 5 and sf.a.isnum():  # and sf.b.isnum():
                    assert sf.b.isnum(), "this should not happen"
                    en = sf
                    return
            if sf.a is not None:
                explode_r(sf.a, d+1)
            if sf.b is not None:
                explode_r(sf.b, d+1)

        explode_r(self, d=1)

        # do the changes (if it explodes)
        if en is not None:
            #print("EXPLODE:", en)
            if ln is not None:
                ln.n += en.a.n
            if nn is not None:
                nn.n += en.b.n
            en.a = None
            en.b = None
            en.n = 0
            return True
        else:
            return False

    def split(self) -> bool:
        spl = False

        def split_num(sf):
            assert sf.isnum()
            a = SF(n=int(floor(sf.n / 2)))
            b = SF(n=int(ceil(sf.n / 2)))
            return SF(a=a, b=b)

        def split_r(sf):
            nonlocal spl
            assert not sf.isnum()
            if spl:
                return
            if sf.a.isnum() and sf.a.n > 9:
                ss = split_num(sf.a)
                sf.a = split_num(sf.a)
                spl = True
                return
            if sf.a and not sf.a.isnum():
                split_r(sf.a)
            if spl:
                return
            if sf.b.isnum() and sf.b.n > 9:
                sf.b = split_num(sf.b)
                spl = True
                return
            if sf.b and not sf.b.isnum():
                split_r(sf.b)

        split_r(self)
        return spl

    def reduce(self):
        i = 0
        while True:
            i += 1
            if self.explode():
                continue
            if self.split():
                continue
            break

    def add(self, other: 'SF'):
        self.a = copy.copy(self)
        self.b = other
        self.n = None
        self.reduce()

    def magnitude(self) -> int:
        def mag_r(sf):
            if sf.isnum():
                return sf.n
            else:
                a = mag_r(sf.a)
                b = mag_r(sf.b)
                return 3 * a + 2 * b
        return mag_r(self)


def parse(instr: str):
    def parse_r(itr):
        d = next(itr)
        if d == ',':
            d = next(itr)
        if d == '[':
            a = parse_r(itr)
            b = parse_r(itr)
            assert next(itr) == ']'
            return SF(a=a, b=b)
        else:
            assert d.isdigit()
            return SF(n=int(d))

    return parse_r(iter(instr))


assert str(parse('[[[[[9,8],1],2],3],4]')) == '[[[[[9,8],1],2],3],4]'


def test_explode(a, b):
    sf = parse(a)
    assert sf.explode()
    assert str(sf) == b


test_explode('[[[[[9,8],1],2],3],4]', '[[[[0,9],2],3],4]')
test_explode('[7,[6,[5,[4,[3,2]]]]]', '[7,[6,[5,[7,0]]]]')
test_explode('[[6,[5,[4,[3,2]]]],1]', '[[6,[5,[7,0]]],3]')
test_explode('[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]',
             '[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]')
test_explode('[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]',
             '[[3,[2,[8,0]]],[9,[5,[7,0]]]]')


sf = parse('[2,[9,3]]')
sf.b.a.n = 11
assert sf.split() == True
assert str(sf) == '[2,[[5,6],3]]'

assert parse("[[1,2],[[3,4],5]]").magnitude() == 143

ex1 = parse("[[[[4,3],4],4],[7,[[8,4],9]]]")
ex2 = parse('[1,1]')
ex1.add(ex2)
assert str(ex1) == '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]'


ls2 = """
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
""".strip().splitlines()


def sfsum(ls: List[str]) -> SF:
    sf = parse(ls[0])
    for ns in ls[1:]:
        n = parse(ns)
        sf.add(n)
    return sf


def part1(ls: List[str]) -> int:
    sm = sfsum(ls)
    return sm.magnitude()


assert str(
    sfsum(ls2)) == "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"

ls3 = """
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
""".strip().splitlines()


assert part1(ls3) == 4140

data = open("input.txt").read().splitlines()
print("PART1:", part1(data))


def part2(data):
    return max(
        max(sfsum([data[i], data[j]]).magnitude(),
            sfsum([data[j], data[i]]).magnitude())
        for i in range(len(data)-1)
        for j in range(i+1, len(data))
    )


print("PART2:", part2(data))
