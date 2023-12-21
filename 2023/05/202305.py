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
print(seed_ranges)
print(coalesce(seed_ranges))


assert set(seed_ranges) == set(coalesce(seed_ranges))
seed_ranges = coalesce(seed_ranges)
print(seed_ranges)
# for map in maps:
#   new_ranges = []
#   for to,frm,n in map:
#     for seed_range in seed_ranges:
#       y = range(frm, frm+n)
#       delta = to - frm
#       before,during,after = range_partition(seed_range, y)
#       new_during = range(during.start+delta, during.stop+delta)
#       #print(seed_range, (to,frm,n), [before,new_during,after])
#       new_ranges.extend(
#         coalesce([before, new_during, after]))
#   seed_ranges = coalesce(new_ranges)

# print(seed_ranges)
# print(min(r.start for r in seed_ranges))