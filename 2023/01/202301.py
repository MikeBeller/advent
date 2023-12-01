digs = lambda s: [c for c in s if "0" <= c <= "9"]
code = lambda ds: int(ds[0]+ds[-1])
input = open("input.txt").read().splitlines()
print("PART1:", sum(code(digs(line)) for line in input))

words = "one two three four five six seven eight nine".split()

def fd(line):
  for i in range(len(line)):
    if "0" <= line[i] <= "9":
      return int(line[i])
    for n,w in enumerate(words):
      if line.startswith(w, i):
        return n + 1

def ld(line):
 for i in range(len(line)-1,-1,-1):
   if "0" <= line[i] <= "9":
     return int(line[i])
   for n,w in enumerate(words):
     if line.startswith(w, i):
       return n + 1

def part2(input):
  return sum(fd(line) * 10 + ld(line) for line in input)

tinput = open("tinput.txt").read().splitlines()
assert (part2(tinput)) == 281
print("PART2:", part2(input))