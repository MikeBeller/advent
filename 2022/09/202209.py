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
          
assert (-1, 0) == move((0, 0), 'U', 1)

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

assert move_tail((0, 0), (0, 2)) == (0, 1)
assert move_tail((2, 2), (2, 1)) == (2, 1)
assert move_tail((1, 1), (-1, 2)) == (0, 1)

def dump(H, T, visited):
  for r in range(-5,6):
    for c in range(-5, 6):
      if (r, c) == T:
        print('T', end='')
      elif (r, c) == H:
        print('H', end='')
      elif (r, c) in visited:
        print('#', end='')
      else:
        print('•', end='')
    print()
  print()


def part1(data):
    visited = set([(0, 0)])
    H = T = (0, 0)
    for i,(s, t) in enumerate(data):
        #print("STEP:", i, s, t)
        for i in range(t):
          H = move(H, s, 1)
          T = move_tail(H, T)
          visited.add(T)
          #dump(H,T,visited)
    return len(visited)

tinput = parse_input(open("tinput.txt").read())
assert part1(tinput) == 13
input = parse_input(open("input.txt").read())
print("PART1:", part1(input))

def part2(data):
  visited = set([(0, 0)])
  knots = [(0,0)] * 10
  for si,(s, t) in enumerate(data):
      #print("STEP:", si, s, t)
      for i in range(t):
        knots[0] = move(knots[0], s, 1)
        for k in range(1,10):
          knots[k] = move_tail(knots[k-1], knots[k])
        visited.add(knots[-1])
        #dump(H,T,visited)
  return len(visited)

assert part2(tinput) == 1
tinput2 = parse_input(open("tinput2.txt").read())
assert part2(tinput2) == 36

print("PART2:", part2(input))