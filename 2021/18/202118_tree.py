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
        expl = False

        def explode_r(sf, d=0):
            nonlocal ln, nn, expl
            if sf.isnum():
                if nn is not None:
                    sf.n += nn
                    nn = None
                    return  # exploding done
                else:
                    ln = sf  # keep track of 'last number seen'
                    return  # no recurse on numbers

            if not expl and d == 4 and (sf.a is not None) and sf.a.isnum() and (sf.b is not None) and sf.b.isnum():
                if ln is not None:
                    ln.n += sf.a.n
                nn = sf.b.n
                sf.a = None
                sf.b = None
                sf.n = 0
                expl = True
            if sf.a is not None:
                explode_r(sf.a, d=d+1)
            if sf.b is not None:
                explode_r(sf.b, d=d+1)

        explode_r(self)
        return expl

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
                sf.a = split_num(sf.a)
                spl = True
                return
            elif sf.b.isnum() and sf.b.n > 9:
                sf.b = split_num(sf.b)
                spl = True
                return
            if sf.a and not sf.a.isnum():
                split_r(sf.a)
            if sf.b and not sf.b.isnum():
                split_r(sf.b)

        split_r(self)
        return spl

    def reduce(self):
        while self.explode() or self.split():  # 'or' will short circuit appropriately
            continue

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

# mutable so have to test carefully
sf = parse('[[[[[9,8],1],2],3],4]')
assert sf.explode() == True
assert str(sf) == '[[[[0,9],2],3],4]'

sf = parse('[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]')
assert sf.explode() == True
assert str(sf) == '[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]'

sf = parse('[2,[9,3]]')
sf.b.a.n = 11
assert sf.split() == True
assert str(sf) == '[2,[[5,6],3]]'

assert parse("[[1,2],[[3,4],5]]").magnitude() == 143

ex1 = parse("[[[[4,3],4],4],[7,[[8,4],9]]]")
ex2 = parse('[1,1]')
ex1.add(ex2)
assert str(ex1) == '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]'


def sflist(strs):
    return [parse(s) for s in strs]


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


def part1(ls: List[SF]) -> int:
    sf = ls[0]
    for n in ls[1:]:
        sf.add(n)
        print(sf)
    print(sf)
    print(sf.magnitude())
    return sf.magnitude()


#assert pr(sum(ls2)) == "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"
print(part1(ls2))

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


assert part1(ls3) == 4140
