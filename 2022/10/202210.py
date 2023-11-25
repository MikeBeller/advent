def parse(input):
  return [
    None if line.startswith("noop")
      else int(line.strip().split()[1])
    for line in input.splitlines() ]

def proc(prog):
  X = 1
  cycle = 1
  yield cycle, X
  for inst in prog:
    if inst is None:
      cycle += 1
      yield cycle, X
    else:
      cycle += 1
      yield cycle, X
      X += inst
      cycle += 1
      yield cycle, X

def part1(prog):
  return sum(C * X for C,X in proc(prog)
            if (C - 20) % 40 == 0)

tinput = parse(open("tinput.txt").read())
assert part1(tinput) == 13140
input = parse(open("input.txt").read())
print(part1(input))