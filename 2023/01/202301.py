import re
input = open("input.txt").read().splitlines()
print(sum(
  int(g[0]+g[-1])
  for line in input if (g := re.findall(r"([1-9])", line))))

words = "one two three four five six seven eight nine".split()
vals = {**{d:int(d) for d in "123456789"}, **{w:i+1 for i,w in enumerate(words)}}
rx = r"[1-9]|" + "|".join(words)
print(sum(
  int(vals[g[0]]*10+vals[g[-1]])
  for line in input if (g := re.findall(rx, line))))