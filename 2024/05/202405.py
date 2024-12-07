from collections import defaultdict
def parse(s):
  rss, uss = s.strip().split("\n\n")
  rules = defaultdict(set)
  for line in rss.splitlines():
    xx,yy = line.strip().split("|")
    rules[int(xx)].add(int(yy))
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