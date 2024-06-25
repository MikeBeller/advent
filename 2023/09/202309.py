from numpy import *

tinput = loadtxt("tinput.txt", dtype=int64)
input = loadtxt("input.txt", dtype=int64)

def dec(r):
  rs = []
  while any(r):
    rs.append(r)
    r = diff(r)
  return sum([r[-1] for r in rs])

def part1(d):
  return sum(apply_along_axis(dec, 1, d))

assert part1(tinput) == 114
print(part1(input))