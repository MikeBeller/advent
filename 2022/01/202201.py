def read_data(filename):
  with open(filename) as f:
    return [ [int(line)
      for line in group.splitlines()]
        for group in f.read().split('\n\n')]

tinput = read_data("tinput.txt")
input = read_data("input.txt")

def part1(data):
  return max(sum(x) for x in data)

assert part1(tinput) == 24000
print("PART1", part1(input))

def part2(data):
  return sum(list(sorted(sum(x) for x in data))[-3:])

assert part2(tinput) == 45000
print("PART2", part2(input))
