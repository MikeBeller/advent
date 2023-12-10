import re
def scores(inp):
  for line in inp.splitlines():
    cn,ws,hs = re.match(r"Card\s+(\d+): ([^|]+)\| (.+)$", line).groups()
    wins = set(ws.strip().split())
    haves = set(hs.strip().split())
    ln = len(wins & haves)
    yield 0 if ln == 0 else 2**(ln-1)

print(sum(scores(open("input.txt").read())))
