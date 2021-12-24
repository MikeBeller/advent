from itertools import islice


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
    print(r)
    return r


assert read_hex_packet("D2FE28") == (6, 4, 2021)
assert read_hex_packet("38006F45291200") == (1, 6, [(6, 4, 10), (2, 4, 20)])
assert read_hex_packet("EE00D40C823060") == (
    7, 3, [(2, 4, 1), (4, 4, 2), (1, 4, 3)])
