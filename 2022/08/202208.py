def parse(instr):
    return [
        [int(ch) for ch in line]
        for line in instr.splitlines()]


def part1(gr):
    nr, nc = len(gr), len(gr[0])
    vis = {}
    for r in range(nr):
        mx = -1
        for c in range(nc):
            if gr[r][c] > mx:
                vis[r,c] = True
                mx = gr[r][c]
        mx = -1
        for c in range(nc-1, -1, -1):
            if gr[r][c] > mx:
                vis[r,c] = True
                mx = gr[r][c]
    for c in range(nc):
        mx = -1
        for r in range(nr):
            if gr[r][c] > mx:
                vis[r,c] = True
                mx = gr[r][c]
        mx = -1
        for r in range(nr-1, -1, -1):
            if gr[r][c] > mx:
                vis[r,c] = True
                mx = gr[r][c]
    return len(vis)


tinput = parse(open('tinput.txt').read())
assert part1(tinput) == 21
input = parse(open('input.txt').read())
print("PART1:", part1(input))
