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

def range_partition(x, y):
  "split range x into before, in, after y"
  fst = max(x.start, y.start)
  lst = min(x.stop, y.stop)
  return range(x.start, fst), range(fst,lst), range(lst, x.stop)

def coalesce(ranges):
  ranges.sort(key=lambda a: a.start)
  new_ranges = [ranges[0]]
  for i in range(1,len(ranges)):
    r , nr = ranges[i], new_ranges[-1]
    if nr.stop > r.start:
      new_ranges[-1] = range(nr.start,max(nr.stop, r.stop))
    else:
      new_ranges.append(r)
  return new_ranges

seed_ranges = [range(seeds[i],seeds[i]+seeds[i+1]) for i in range(0,len(seeds)-1, 2)]

assert set(seed_ranges) == set(coalesce(seed_ranges))
seed_ranges = coalesce(seed_ranges)

def apply_stage(map, ranges):
  new_ranges = []
  for to,frm,n in map:
    y = range(frm, frm+n)
    delta = to - frm
    skipped_ranges = []
    for r in ranges:
      before, during, after = range_partition(r, y)
      if len(during) > 0:
        new_ranges.append(range(during.start+delta, during.stop+delta))
      skipped_ranges.extend((before, after))
    ranges = skipped_ranges
  new_ranges.extend(skipped_ranges)
  cranges = coalesce(new_ranges)
  return cranges

ranges = seed_ranges.copy()
print(ranges)
for map in maps:
  ranges = apply_stage(map, ranges)
  print(ranges)
  
print(min(r.start for r in ranges))
