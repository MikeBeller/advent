def parse(inp):
  path,rest = inp.strip().split("\n\n")
  mp = {}
  for line in rest.strip().splitlines():
    k,l,r = line[0:3], line[7:10], line[12:15]
    mp[k] = (l,r)
  return path,mp

def repeat(s):
  while True:
    for c in s:
      yield c

tinput = parse(open("tinput.txt").read())
input = parse(open("input.txt").read())

def part1(data):
  path,mp = data
  node = "AAA"
  for i, c in enumerate(repeat(path)):
    node = mp[node][0] if c == "L" else mp[node][1]
    if node == "ZZZ":
      return i + 1

assert part1(tinput) == 2
print(part1(input))
    