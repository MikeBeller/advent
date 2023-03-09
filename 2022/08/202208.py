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

def part2(gr):
  nr, nc = len(gr), len(gr[0])
  return max(score(gr, r, c, nr, nc) for r in range(nr) for c in range(nc))

def score(gr, r, c, nr, nc):
  return prod(drscore(gr, r, c, nr, nc, dr) for dr in range(4))

from functools import reduce
def prod(lst):
  return reduce(lambda x, y: x*y, lst, 1)

def drscore(gr, r, c, nr, nc, dr):
  s = 0
  h = gr[r][c]
  rr,cc = move(r, c, dr)
  while rr < nr and cc < nc and rr >= 0 and cc >= 0:
    s += 1
    if gr[rr][cc] >= h:
      break
    rr, cc = move(rr, cc, dr)
  #print(r, c, dr, s)
  return s

def move(r, c, dr):
  if dr == 0:
    return r-1, c
  elif dr == 1:
    return r, c + 1
  elif dr == 2:
    return r + 1, c
  elif dr == 3:
    return r, c-1

assert score(tinput, 1, 2, len(tinput), len(tinput[0])) == 4
print("PART2:", part2(input))
