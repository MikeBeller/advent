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

tinput3 = parse(open("tinput3.txt").read())

def part2(data):
	path,mp = data
	ghosts = [s for s in mp.keys()
	  if s.endswith("A")]
	count = 0
	steps = 0
	rpath = repeat(path)
	while count < len(ghosts):
		count = 0
		d = next(rpath)
		for i,g in enumerate(ghosts):
			ghosts[i] = mp[g][0] if d == "L" else mp[g][1]
			if ghosts[i].endswith("Z"):
				count += 1
		steps += 1
	return steps
			
assert part2(tinput3) == 6
print(part2(input))
