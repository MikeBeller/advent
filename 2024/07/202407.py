def parse(s):
  eqs = []
  for line in s.strip().splitlines():
    first,rest = line.split(":")
    t = int(first)
    vs = [int(s) for s in rest.strip().split()]
    eqs.append((t, vs))
  return eqs

def bits(n):
  while True:
    yield n & 1
    n = n >> 1

def check_combo(test, vs, ops):
  tot = vs[0]
  for op,d in zip(ops, vs[1:]):
    if op == 0:
      tot += d
    elif op == 1:
      tot *= d
    elif op == 2:
      tot = int(str(tot) + str(d))
    if tot > test:
      return False
  return tot == test
    
def part1(eqs):
  score = 0
  for test,vs in eqs:
    nd = len(vs)
    for o in range(2**(nd-1)):
      ops = bits(o)
      if check_combo(test, vs, ops):
        score += test
        break
  return score

tinput = parse(open("tinput.txt").read())
input = parse(open("input.txt").read())
assert part1(tinput) == 3749
print(part1(input))

def trits(n):
  while True:
    d = n % 3
    n = n // 3
    yield d
    
def part2(eqs):
  score = 0
  for test,vs in eqs:
    nd = len(vs)
    for o in range(3**(nd-1)):
      ops = trits(o)
      if check_combo(test, vs, ops):
        score += test
        break
  return score

assert part2(tinput) == 11387
print(part2(input))