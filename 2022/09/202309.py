def parse_input(instr):
    return [(s, int(t))
            for s, t in (line.strip().split(' ', 1)
                         for line in instr.splitlines())]


def move(p, s, t):
    r, c = p
    match s:
        case 'U': return (r-t, c)
        case 'D': return (r+t, c)
        case 'L': return (r, c-t)
        case 'R': return (r, c+t)


def part1(data):
    visited = set()
    H = T = (0, 0)
    for s, t in data:
        H = move(H, s, t)
        if abs(H[0] - T[0]) == 2:
            T = (T[0] + (H[0] - T[0])//2, T[1])
        elif abs(H[1] - T[1]) == 2:
            T = (T[0], T[1] + (H[1] - T[1])//2)
        elif abs(H[0] - T[0]) <= 1 and abs(H[1] - T[1]) <= 1:
            pass
        else:
            # move T one step diagonally towards H
            d0 = 1 if H[0] > T[0] else -1
            d1 = 1 if H[1] > T[1] else -1
            T = (T[0] + d0, T[1] + d1)
        visited.add(T)
    return len(visited)


assert (-1, 0) == move((0, 0), 'U', 1)

tinput = parse_input(open("tinput.txt").read())
print(part1(tinput))
