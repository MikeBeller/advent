
def parse(instr):
    return [
        [int(c) for c in line]
        for line in instr.splitlines()
    ]

def part1(g):
    nr, nc = len(g), len(g[0])
    visible = {}
    for r in range(1,nr-1):
        for c in range(1,nc):
            if g[r][c] > g[r][c-1]:
                visible[r,c] = True
            else:
                break
        for c in range(nc-2,0,-1):
            if g[r][c] > g[r][c+1]:
                visible[r,c] = True
            else:
                break
    for r in range(nr-1,0,-1):
        for c in range(1,nc):
            if g[r][c] > g[r][c-1]:
                visible[r,c] = True
            else:
                break
        for c in range(nc-2,0,-1):
            if g[r][c] > g[r][c+1]:
                visible[r,c] = True
            else:
                break
    return sum(visible.values()) + 2 * nr + 2 * nc - 4

tinput = parse(open('tinput.txt').read())
print(part1(tinput))


