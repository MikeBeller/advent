from dataclasses import dataclass


@dataclass
class SF:
    p: None
    a: None
    b: None
    n: int


def parse_r(itr, p=None):
    d = next(itr)
    if d == ',':
        d = next(itr)
    if d == '[':
        nn = SF(p=p)
        a = parse_r(itr, nn)
        b = parse_r(itr, nn)
        assert next(itr) == ']'
        nn.a = a
        nn.b = b
        return
    else:
        assert d.isdigit()
        return SF(p=p, n=int(d))


def parse(instr: str):
    return parse_r(iter(instr))


assert parse('[[[[[9,8],1],2],3],4]') == (((((9, 8), 1), 2), 3), 4)


def explode(num):
    ln = None
    t = None
    nn = None

    def explode_r(num, d):
        a, b = num
        if d == 5 and isinstance(a, int) and isinstance(b, int):
            t = num
            return 0
        if not t:
            if isinstance(b, int):
                ln = b
            elif isinstance(a, int):
                ln = a
        else:
            if not nn and isinstance(a, int):
                nn = a
