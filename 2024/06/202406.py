from copy import deepcopy

def parse(inp):
  return [
    [c for c in line]
    for line in inp.strip().splitlines()
  ]

tinput = parse(open("tinput.txt").read())
input = parse(open("input.txt").read())

def find_guard(m):
  for r in range(len(m)):
    for c in range(len(m[0])):
      d = "^>v<".find(m[r][c])
      if d >=0:
        return (r,c),d
  assert False, 'no guard'

def nxt(m,p,d):
  r,c = p
  oob = (0,0),''
  if d == 0:
    r -= 1
    if r < 0: return oob
  elif d == 1:
    c += 1
    if c >= len(m[0]): return oob
  elif d == 2:
    r += 1
    if r >= len(m): return oob
  else:
    c -= 1
    if c < 0: return oob
  return (r,c),m[r][c]

def turn(d):
  return (d + 1) % 4

def part1(m):
  m = deepcopy(m)
  p,d = find_guard(m)
  r,c = p
  m[r][c] = 'X'
  while True:
    p2,ch = nxt(m,p,d)
    if ch == '':
      break
    elif ch == '#':
      d = turn(d)
      continue
    p = p2
    r,c = p
    m[r][c] = 'X'

  return sum(1 for r in range(len(m))
             for c in range(len(m[0]))
             if m[r][c] == 'X')

assert part1(tinput) == 41
print(part1(input))

def it_loops(m, rr, cc):
  m = deepcopy(m)
  m[rr][cc] = '#'
  visited = [[set() for rrr in m ] for ccc in m[0]]
  p,d = find_guard(m)
  r,c = p
  m[r][c] = 'X'
  visited[r][c] = {d}
  while True:
    p2,ch = nxt(m,p,d)
    if ch == '':
      return False
    elif ch == '#':
      d = turn(d)
      continue
    p = p2
    r,c = p
    if d in visited[r][c]:
      return True
    m[r][c] = 'X'
    visited[r][c].add(d)

def part2(m):
  nr,nc = len(m), len(m[0])
  count = 0
  for r in range(nr):
    for c in range(nc):
      if m[r][c] == '.':
        if it_loops(m, r, c):
          count += 1
  return count

assert part2(tinput) == 6
print(part2(input))