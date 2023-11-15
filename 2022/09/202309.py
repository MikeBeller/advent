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


def move_tail(H, T):
    match (H[0] - T[0], H[1] - T[1]):
        case (dr, dc) if abs(dr) < 2 and abs(dc) < 2: return T
        case (d, 0) if abs(d) == 2: return (T[0] + d//2, T[1])
        case (0, d) if abs(d) == 2: return (T[0], T[1] + d//2)
        case _:
            # move T one step diagonally towards H
            dr = 1 if H[0] > T[0] else -1
            dc = 1 if H[1] > T[1] else -1
            return (T[0] + dr, T[1] + dc)


def part1(data):
    visited = set((0, 0))
    H = T = (0, 0)
    for s, t in data:
        H = move(H, s, t)
        T = move_tail(H, T)
        visited.add(T)
    return len(visited)


assert (-1, 0) == move((0, 0), 'U', 1)

tinput = parse_input(open("tinput.txt").read())
print(part1(tinput))
