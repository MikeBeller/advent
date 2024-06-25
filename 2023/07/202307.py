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
  
def run(inp, scorer):
  data = [(scorer(code), code, weight)
          for code, weight in inp]
  data.sort()
  #print(data)
  return sum((i+1) * weight
    for i,(hand,code,weight) in enumerate(data))

def part1(inp):
  return run(inp, hand_score)

assert part1(tinput) == 6440
print(part1(input))

def hand_score_2(code):
  cc = code.replace("1", "")
  nj = 5 - len(cc)
  if nj == 5:
    return (5,)
  else:
    sc = list(hand_score(cc))
    sc[0] += nj
    return tuple(sc)

def part2(inp):
  inp = [(c.replace("J","1"),w) for c,w in inp]
  return run(inp, hand_score_2)

assert part2(tinput) == 5905
print(part2(input))