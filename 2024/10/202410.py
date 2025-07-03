from dataclasses import dataclass

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
    
def paths(mp: Map, st: Point, v: set(Point)=set()) -> int:
  if v in st:
    return 0
  if mp[st] == 9:
    return 1
  v.add(st)
  moves = [(c,r) for (c,r) in [move(st,d) for d in [U,R,D,L]]
           if mp.valid((c,r)) ]
  return sum(paths(mp, mv, v) for mv in moves
             if mp[mv] - mp[st] == 1)

paths(tinput, (0,0))