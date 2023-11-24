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

def dump(H, T, visited):
  for r in range(min(H[0], T[0])-1, max(H[0], T[0])+2):
      for c in range(min(H[1], T[1])-1, max(H[1], T[1])+2):
          if (r, c) == H:
            print('H', end='')
          elif (r, c) == T:
            print('T', end='')
          elif (r, c) in visited:
            print('#', end='')
            # print(f'{r} {c}', end='')
          else:
            print('•', end='')
      print()
  print()

            

def part1(data):
    visited = set((0, 0))
    H = T = (0, 0)
    dump(H,T,visited)
    for s, t in data:
        print(s, t)
        for i in range(t):
          H = move(H, s, 1)
          dump(H,T,visited)
          T = move_tail(H, T)
          visited.add(T)
          dump(H,T,visited)
    return len(visited)


assert (-1, 0) == move((0, 0), 'U', 1)

tinput = parse_input(open("tinput.txt").read())
print(part1(tinput))
