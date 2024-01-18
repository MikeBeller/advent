from math import sqrt, ceil, floor, prod

def parse(s):
  ts,ds = s.splitlines()
  return list(zip(
    [int(x) for x in ts.strip().split()[1:]],
    [int(x) for x in ds.strip().split()[1:]]))

tinput = parse(open("tinput.txt").read())
input = parse(open("input.txt").read())

def solve(t,d):
  sq = sqrt(t*t - 4 * d)
  return (t - sq)/2, (t + sq)/2

def ng(t,d):
  a,b = solve(t,d)
  ac = ceil(a) if a != floor(a) else ceil(a) + 1
  bf = floor(b) if b != floor(b) else floor(b) - 1
  return bf - ac + 1

assert ng(7,9) == 4
assert ng(15,40) == 8
assert ng(30, 200) == 9

def part1(inp):
  return prod(ng(*x) for x in inp)

assert part1(tinput) == 288
print(part1(input))

def part2(inp):
  T = float("".join(str(t) for t,d in inp))
  D = float("".join(str(d) for t,d in inp))
  return ng(T,D)

assert part2(tinput) == 71503
print(part2(input))