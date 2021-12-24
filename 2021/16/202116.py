from itertools import islice
from functools import reduce


def gen_hex_bits():
    tab = {}
    for n, c in enumerate('0123456789ABCDEF'):
        tab[c] = [(n & (1 << i)) >> i for i in range(3, -1, -1)]
    return tab


hex_bits = gen_hex_bits()


def read_hex(hstr):
    for c in hstr:
        for b in hex_bits[c]:
            yield b


def read_num(bits, n):
    r = 0
    for i in range(n):
        r = 2 * r + next(bits)
    return r


def read_literal(bits):
    r = 0
    while True:
        b = next(bits)
        d = read_num(bits, 4)
        r = r * 16 + d
        if b == 0:
            break
    return r


def read_packet(bits):
    ver = read_num(bits, 3)
    typ = read_num(bits, 3)
    if typ == 4:  # literal
        val = read_literal(bits)
        return (ver, typ, val)
    else:
        lt = next(bits)
        if lt == 0:
            nbits = read_num(bits, 15)
            sub_bits = islice(bits, nbits)
            ls = []
            try:
                while True:
                    ls.append(read_packet(sub_bits))
            except StopIteration:
                return (ver, typ, ls)
        else:
            npkts = read_num(bits, 11)
            return (ver, typ, [read_packet(bits) for _ in range(npkts)])


def read_hex_packet(hex):
    r = read_packet(read_hex(hex))
    return r


assert read_hex_packet("D2FE28") == (6, 4, 2021)
assert read_hex_packet("38006F45291200") == (1, 6, [(6, 4, 10), (2, 4, 20)])
assert read_hex_packet("EE00D40C823060") == (
    7, 3, [(2, 4, 1), (4, 4, 2), (1, 4, 3)])


def version_sum(pkt):
    (ver, typ, val) = pkt
    if typ == 4:
        return ver
    else:
        return ver + sum(version_sum(p) for p in val)


def part1(hex_str):
    pkt = read_packet(read_hex(hex_str))
    return version_sum(pkt)


assert part1("8A004A801A8002F478") == 16
assert part1("620080001611562C8802118E34") == 12
assert part1("C0015000016115A2E0802F182340") == 23
assert part1("A0016C880162017C3686B18A3D4780") == 31


def prod(ns):
    return reduce(lambda a, b: a * b, ns)


def eval_expr(pkt):
    (ver, typ, val) = pkt
    if typ == 4:
        return val
    else:
        if typ == 0:
            return sum(eval_expr(p) for p in val)
        elif typ == 1:
            return prod(eval_expr(p) for p in val)
        elif typ == 2:
            return min(eval_expr(p) for p in val)
        elif typ == 3:
            return max(eval_expr(p) for p in val)
        elif typ == 5:
            p1, p2 = val
            return 1 if eval_expr(p1) > eval_expr(p2) else 0
        elif typ == 6:
            p1, p2 = val
            return 1 if eval_expr(p1) < eval_expr(p2) else 0
        elif typ == 7:
            p1, p2 = val
            return 1 if eval_expr(p1) == eval_expr(p2) else 0


def part2(hex_str):
    pkt = read_packet(read_hex(hex_str))
    return eval_expr(pkt)


data = open("input.txt").read()
print("PART1:", part1(data))

assert part2("C200B40A82") == 3
assert part2("04005AC33890") == 54
assert part2("880086C3E88112") == 7
assert part2("CE00C43D881120") == 9
assert part2("D8005AC2A8F0") == 1
assert part2("F600BC2D8F") == 0
assert part2("9C005AC2F8F0") == 0
assert part2("9C0141080250320F1802104A08") == 1

print("PART2:", part2(data))
