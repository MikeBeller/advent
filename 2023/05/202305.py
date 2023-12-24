from advent import parse
fname = "input.txt"
sseed,*smaps = open(fname).read().split("\n\n")
seeds = parse("xI", sseed)
maps = [[parse("I", line)
         for line in sm.splitlines()[1:]]
            for sm in smaps]

def trans(map, seed):
  for to,frm,n in map:
    if frm <= seed < frm + n:
      return seed - frm + to
  return seed
  
def seed_to_loc(maps, seed):
  for map in maps:
    seed = trans(map, seed)
  return seed # loc

print(min(seed_to_loc(maps, s) for s in seeds))

def intersects(x,y):
  assert x.start < x.stop and y.start < y.stop
  return not (
    x.stop < y.start or x.start > y.stop)

def range_partition(x, y):
  "split range x into before, in, after y"
  fst = max(x.start, y.start)
  lst = min(x.stop, y.stop)
  return range(x.start, fst), range(fst,lst), range(lst, x.stop)

assert range_partition(range(5,10), range(1,3))
seed_ranges = [range(seeds[i],seeds[i]+seeds[i+1]) for i in range(0,len(seeds)-1, 2)]

def apply_stage(map, ranges):
  nrs = []
  for r in ranges:
    rs = [r]
    for t,f,n in map:
      to = range(t,t+n)
      frm = range(f,f+n)
      for rr in rs[:]:
        if intersects(rr,frm):
          rs.remove(rr)
          a,b,c = range_partition(rr,frm)
          b = range(b.start+t-f, b.stop+t-f)
          nrs.append(b)
          rs.extend(x for x in (a,c) if len(x) > 0)
    nrs.extend(rs)
  return nrs

def part2(maps, seed_ranges):
  ranges = seed_ranges.copy()
  for map in maps:
    ranges = apply_stage(map, ranges)
  return min(r.start for r in ranges)

print(part2(maps, seed_ranges))
