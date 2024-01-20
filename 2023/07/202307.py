def parse(inp):
  return [(f[0].replace("K","R").replace("A","Z").replace("T","D"), int(f[1]))
   for line in inp.splitlines()
    if len(f := line.split()) == 2]

tinput = parse(open("tinput.txt").read())
input = parse(open("input.txt").read())

from collections import Counter
def hand_score(code):
  return tuple(sorted(Counter(code).values(), reverse=True))

assert hand_score("RR677") == (2, 2, 1)
  
def part1(inp):
  data = [(hand_score(code), code, score)
          for code, score in inp]
  data.sort()
  return sum((i+1) * score
    for i,(hand,code,score) in enumerate(data))

assert part1(tinput) == 6440
print(part1(input))