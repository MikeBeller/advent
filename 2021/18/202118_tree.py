from dataclasses import dataclass


@dataclass
class SF:
    a: 'SF' = None
    b: 'SF' = None
    n: int = None

    def isnum(self):
        return self.n is not None


def pr(sf: SF) -> str:
    if sf.isnum():
        return str(sf.n)
    else:
        return "[" + pr(sf.a) + "," + pr(sf.b) + "]"


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


def parse(instr: str):
    return parse_r(iter(instr))


assert pr(parse('[[[[[9,8],1],2],3],4]')) == '[[[[[9,8],1],2],3],4]'


def explode(sf):
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

    explode_r(sf)
    return sf


assert pr(explode(parse('[[[[[9,8],1],2],3],4]'))) == '[[[[0,9],2],3],4]'
assert pr(explode(parse('[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]'))
          ) == '[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]'
