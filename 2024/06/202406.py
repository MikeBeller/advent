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
  p,d = find_guard(m)
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