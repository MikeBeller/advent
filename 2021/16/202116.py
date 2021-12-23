
def dig_bits(n):
    return


def gen_bits():
    tab = {}
    for n, c in enumerate('0123456789ABCDEF'):
        tab[c] = [(n & (1 << i)) >> i for i in range(3, -1, -1)]
    return tab


bits = gen_bits()


def read_bits(hstr):
    for c in hstr:
        for b in bits[c]:
            yield b


#t1 = parse("DFE28")
# print(t1)
