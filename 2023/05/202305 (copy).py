from advent import parse
fname = "tinput.txt"
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
  return max(x.start, y.start) < min(x.stop, y.stop)

def range_partition(x, y):
  "split range x into before, in, after y"
  fst = max(x.start, y.start)
  lst = min(x.stop, y.stop)
  return range(x.start, fst), range(fst,lst), range(lst, x.stop)

assert range_partition(range(5,10), range(1,3))
  
def coalesce(ranges):
  ranges = sorted([r for r in ranges if len(r) > 0], key=lambda a: a.start)
  if len(ranges) == 0: return []
  coalesced = [ranges[0]]
  for i in range(1,len(ranges)):
    r, cr = ranges[i], coalesced[-1]
    if cr.stop > r.start:
      coalesced[-1] = range(cr.start,max(cr.stop, r.stop))
    else:
      coalesced.append(r)
  return coalesced

assert coalesce([range(1,5),range(3,9)]) == [range(1,9)]
assert coalesce([range(7,10),range(90,90),range(1,3),range(3,9)]) == [range(1,3),range(3,10)]

seed_ranges = [range(seeds[i],seeds[i]+seeds[i+1]) for i in range(0,len(seeds)-1, 2)]

assert set(seed_ranges) == set(coalesce(seed_ranges))
seed_ranges = coalesce(seed_ranges)

def apply_item(to, frm, n, ranges):
  y = range(frm, frm+n)
  delta = to - frm
  unmapped_ranges = []
  mapped_ranges = []
  for r in ranges:
    if intersects(r,y):
      before, during, after = range_partition(r, y)
      if len(during) > 0:
        mapped_ranges.append(
          range(during.start+delta, during.stop+delta))
        unmapped_ranges.extend([x for x in [before, after] if len(x) > 0])
    else:
      unmapped_ranges.append(r)
  return coalesce(mapped_ranges), coalesce(unmapped_ranges)

assert apply_item(50,98,2, [range(79,93), range(55,68)]) == ([], [range(55, 68), range(79, 93)])
assert apply_item(52,50,48, [range(55, 68), range(79, 93)]) == ([range(57, 70), range(81, 95)], [])

def apply_stage(map, ranges):
  mapped_ranges = []
  unmapped_ranges = ranges.copy()
  for to,frm,n in map:
    print(to, frm, n)
    mr,ur = apply_item(to,frm,n,unmapped_ranges)
    print(mr, ur)
    mapped_ranges.extend(mr)
    unmapped_ranges.extend(ur)
  ranges = coalesce(mapped_ranges + unmapped_ranges)
  return ranges

def part2(maps, seed_ranges):
  ranges = seed_ranges.copy()
  print(ranges)
  for map in maps:
    ranges = apply_stage(map, ranges)
    print(ranges)
    #break
  print(min(r.start for r in ranges))

part2(maps, seed_ranges)