from collections import defaultdict
def parse(s):
  rss, uss = s.strip().split("\n\n")
  rules = defaultdict(set)
  for line in rss.splitlines():
    sx,sy = line.strip().split("|")
    rules[int(sx)].add(int(sy))
  updates = [[int(x) for x in line.strip().split(",")]
              for line in uss.splitlines()]
  return rules, updates

def valid(rules, update):
  ok = True
  pages_reversed = list(reversed(update))
  for i in range(0,len(pages_reversed)-1):
    p = pages_reversed[i]
    must_come_after = rules[p]
    remaining_pages = set(pages_reversed[i+1:])
    if len(must_come_after & remaining_pages) > 0:
      return False
  return True

def part1(rules, updates):
  is_valid = [valid(rules, u) for u in updates]
  return sum( [u[len(u)//2]
          for i,u in enumerate(updates)
          if is_valid[i]])

trules, tupdates = parse(open("tinput.txt").read())
assert part1(trules, tupdates) == 143
rules, updates = parse(open("input.txt").read())
print(part1(rules, updates))

def fix(rules, update):
  ok = True
  ps = list(reversed(update))
  for i in range(0,len(ps)-1):
    p = ps[i]
    for j in range(i+1,len(ps)):
      p2 = ps[j]
      if p2 in rules[p]:
        ps[j], ps[i] = ps[i], ps[j]
  return list(reversed(ps))

def part2(rules, updates):
  invalid_updates = [u for u in updates if not valid(rules, u)]
  fixed = []
  for update in invalid_updates:
    u = update.copy()
    while not valid(rules, u):
      u = fix(rules, u)
    fixed.append(u)
  return sum( [u[len(u)//2] for u in fixed])
  
assert part2(trules, tupdates) == 123
print(part2(rules, updates))