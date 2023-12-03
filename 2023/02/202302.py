def parse_draw(ds):
  return {k[0]:int(v) for v,k in [ps.split(" ")
          for ps in ds.split(", ")]}
  
def parse_game(line):
  gms,rss = line.split(": ")
  gi = int(gms.split(" ")[1])
  draws = [parse_draw(ds) for ds in rss.split("; ")]
  return gi, draws

def parse_input(inp):
  return dict(parse_game(line) for line in inp.splitlines())

def maxes(ds):
  r = max(d.get('r', 0) for d in ds)
  g = max(d.get('g', 0) for d in ds)
  b = max(d.get('b', 0) for d in ds)
  return r,g,b
  
tinput = parse_input(open("tinput.txt").read())
input = parse_input(open("input.txt").read())

def part1(data):
  s = 0
  for gi,draws in data.items():
    r,g,b = maxes(draws)
    if r <= 12 and g <= 13 and b <= 14:
      s += gi
  return s

assert part1(tinput) == 8
print(part1(input))

def part2(data):
  s = 0
  for gi,draws in data.items():
    r,g,b = maxes(draws)
    s += r * g * b
  return s

assert part2(tinput) == 2286
print(part2(input))
  