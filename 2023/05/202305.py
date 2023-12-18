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
  "range split into before, in, after y"
  fst = max(x.start, y.start)
  lst = min(x.stop, y.stop)
  return range(x.start, fst), range(fst,lst), range(lst, x.stop)

def coalesce(ranges):
  return set([r for r in ranges if len(r) > 0])

seed_ranges = [range(seeds[i],seeds[i]+seeds[i+1]) for i in range(0,len(seeds)-1, 2)]
seed_ranges = coalesce(seed_ranges)
print(seed_ranges)
for map in maps:
  for to,frm,n in map:
    y = range(frm, frm+n)
    delta = to - frm
    new_ranges = []
    for seed_range in seed_ranges:
      before,during,after = range_partition(seed_range, y)
      new_during = range(during.start+delta, during.stop+delta)
      #print(seed_range, (to,frm,n), [before,new_during,after])
      new_ranges.extend(coalesce([before, new_during, after]))
    seed_ranges = coalesce(new_ranges)

print(seed_ranges)
print(min(r.start for r in seed_ranges))