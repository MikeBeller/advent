
def parse(instr):
  g = {(r,c): int(ch)
            for r,line in enumerate(instr.splitlines())
            for c,ch in enumerate(line)
      }
  nr = max(r for r,c in g.keys()) + 1
  nc = max(c for r,c in g.keys()) + 1
  g['nr'], g['nc'] = nr, nc
  return g

def viz(g, v, nr, nc):
  for r in range(nr):
    for c in range(nc):
      ch = g[r,c] if v.get((r,c)) else '.'
      print(ch, end='')
    print()
  print()

def part1(g):
    nr, nc = g['nr'], g['nc']
    visible = {}
    for r in range(nr):
        for c in range(nc):
            if g[r,c] > g.get((r,c-1),-1):
                visible[r,c] = True
            else:
                break
        for c in range(nc-1,-1,-1):
            if g[r,c] > g.get((r, c+1), -1):
                visible[r,c] = True
            else:
                break
    for c in range(nc):
        for r in range(nr):
            if g[r,c] > g.get((r-1, c),-1):
                visible[r,c] = True
            else:
                break
        for r in range(nr-1,-1,-1):
            if g[r,c] > g.get((r+1, c), -1):
                visible[r,c] = True
            else:
                break
    viz(g, visible, g['nr'], g['nc'])
    return len(visible)

tinput = parse(open('tinput.txt').read())
print(part1(tinput))


