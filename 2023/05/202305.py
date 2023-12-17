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