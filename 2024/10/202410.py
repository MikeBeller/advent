from dataclasses import dataclass
from collections import defaultdict

def p(x):
  print(x)
  return x

Point = tuple[int,int]
Path = frozenset[Point]

class Map:
  def __init__(self, s: str):
    lines = s.splitlines()
    self.nr = len(lines)
    self.nc = len(lines[0])
    self.data = { (c,r): int(ch)
            for r,line in enumerate(s.splitlines())
            for c,ch in enumerate(line)
      }
    self.adj: dict[Point,set] = defaultdict(set)
    self.heads = set()
    self.tails = set()
    for r in range(self.nr):
      for c in range(self.nc):
        p = (c,r)
        if self.data[p] == 0:
          self.heads.add(p)
        elif self.data[p] == 9:
          self.tails.add(p)

        for dr,dc in [(-1,0),(1,0),(0,-1),(0,1)]:
          np = (c + dc,r + dr)
          if np in self.data:
            if self.data[np] - self.data[p] == 1:
              self.adj[p].add(np)

  def __getitem__(self, key):
    return self.data[key]

input = Map(open("input.txt").read())
tinput = Map(open("tinput.txt").read())
    
def find_paths(mp: Map,
               p: Point,
               path: Path=Path(),
               paths: frozenset[Path]=frozenset()) -> frozenset[Path]:
  path = path | frozenset([p])
  if mp[p] == 9:
    return paths | frozenset([path])
  return paths.union(
    *[find_paths(mp, mv, path, paths)
             for mv in mp.adj[p]]
  )

def part1(mp: Map) -> int:
  #print(mp.tails)
  s = 0
  for h in mp.heads:
    r:frozenset[Point] = frozenset()
    ps = find_paths(mp,h)
    for p in ps:
      t = (p & mp.tails)
      r = r | t
    s += len(r)
  return s

assert part1(tinput) == 36
print(part1(input))

def part2(mp: Map) -> int:
  s = 0
  for h in mp.heads:
    ps = find_paths(mp,h)
    #print(h, len(ps))
    s += len(ps)
  return s

assert part2(tinput) == 81
print(part2(input))
