from collections import defaultdict
from itertools import combinations

def parse(s):
  lines = s.strip().splitlines()
  txs = defaultdict(set)
  for r,line in enumerate(lines):
    for c,ch in enumerate(line):
      if ch != '.':
        txs[ch].add((r,c))
  return dict(nr=len(lines), nc=len(lines[0]), txs=txs)

tinput = parse(open("tinput.txt").read())
input = parse(open("input.txt").read())

def anti(p1, p2):
  dr, dc = p2[0] - p1[0], p2[1] - p1[1]
  return p2[0] + dr, p2[1] + dc
  
def part1(d):
  antis = {}
  for ch,ps in d['txs'].items():
    for p1,p2 in combinations(ps, 2):
      antis[anti(p1, p2)] = '#'
      antis[anti(p2, p1)] = '#'
  return sum(1 for (r,c) in antis.keys()
            if 0 <= r < d['nr'] and 0 <= c < d['nc'])


assert part1(tinput) == 14
print(part1(input))
    
  