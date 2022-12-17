def searchn(s, n):
  buf = [""] * n
  ct = {}
  for i in range(len(s)):
    c = s[i]
    io = i % n
    oc = buf[io]
    ct[oc] = max(ct.get(oc, 0) - 1, 0)
    if ct[oc] == 0:
      del ct[oc]
    ct[c] = ct.get(c, 0) + 1
    buf[io] = c
    #print(i, oc, c, ct, buf)
    if len(ct) == n:
      return i+1
  return -1

def part1(s):
  return searchn(s, 4)
  
assert part1("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 7
assert part1("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5
assert part1("nppdvjthqldpwncqszvftbrmjlhg") == 6
assert part1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10
assert part1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11

input = open("input.txt", "r").read().strip()

print(part1(input))

def part2(s):
  return searchn(s, 14)

assert part2("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 19
assert part2("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23
assert part2("nppdvjthqldpwncqszvftbrmjlhg") == 23
assert part2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 29
assert part2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 26

print(part2(input))

def bench(n):
  import time
  t1 = time.time()
  for i in range(n):
    part2(input)
  t2 = time.time()
  print("part2", t2-t1)

bench(1000)
