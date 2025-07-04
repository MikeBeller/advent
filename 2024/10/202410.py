from dataclasses import dataclass

def p(x):
  print(x)
  return x

Point = tuple[int,int]
U,R,D,L = 0,1,2,3

class Map:
  def __init__(self, s: str):
    lines = s.splitlines()
    self.nr = len(lines)
    self.nc = len(lines[0])
    self.data = { (c,r): int(ch)
            for r,line in enumerate(s.splitlines())
            for c,ch in enumerate(line)
      }

  def valid(self, p: Point) -> bool:
    (c,r) = p
    return c >= 0 and c < self.nc and r >=0 and r < self.nr

  def __getitem__(self, key):
    return self.data[key]

input = Map(open("input.txt").read())
tinput = Map(open("tinput.txt").read())

def move(p: Point, d: int):
  (c,r) = p
  if d == U:
    return (c,r-1)
  elif d == R:
    return (c+1,r)
  elif d == D:
    return (c,r+1)
  else: # L
    return (c-1,r)
    
def find_paths(mp: Map, st: Point, path: set(Point)=frozenset(), paths: set(set(Point))=frozenset()) -> frozenset:
  if mp[st] == 9:
    return paths | frozenset([path])
  moves = [(c,r) for (c,r) in [move(st,d) for d in [U,R,D,L]]
           if mp.valid((c,r)) and (c,r) not in path]
  return paths.union(
    *[find_paths(mp, mv, (path | frozenset([st])), paths)
             for mv in moves
             if mp[mv] - mp[st] == 1])

def part1(mp: Map) -> int:
  return sum(
    p(len(find_paths(mp,(c,r))))
      for c in range(mp.nc)
        for r in range(mp.nr)
          if mp[(c,r)] == 0)


# #assert part1(tinput) == 36
print(part1(tinput))

