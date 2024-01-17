from functools import reduce

def parse(s):
  ts,ds = s.splitlines()
  return list(zip(
    [int(x) for x in ts.strip().split()[1:]],
    [int(x) for x in ds.strip().split()[1:]]))

tinput = parse(open("tinput.txt").read())
input = parse(open("input.txt").read())

def dt(t,n):
  assert n > 0 and n < t
  return n * (t - n)

def ng(t,d):
  return sum(1 for n in range(1,t-1)
            if dt(t,n) > d)

assert ng(7,9) == 4
assert ng(15,40) == 8
assert ng(30, 200) == 9

def part1(inp):
  return reduce(lambda a,x: a * ng(*x), inp, 1)

assert part1(tinput) == 288
print(part1(input))