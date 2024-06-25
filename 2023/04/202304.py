import re,collections
def scores(inp):
  for line in inp.splitlines():
    cn,ws,hs = re.match(r"Card\s+(\d+): ([^|]+)\| (.+)$", line).groups()
    wins = set(ws.strip().split())
    haves = set(hs.strip().split())
    yield int(cn), len(wins & haves)

sc = list(scores(open("input.txt").read()))
print(sum((0 if ln == 0 else 2**(ln-1)) for _,ln in sc))

def crds(sc ):
  cs=collections.defaultdict(int)
  for cn,ln in sc:
    cs[cn] += 1
    for i in range(ln):
      cs[cn+i+1] += cs[cn]
  return cs

#print(crds(sc))
print(sum(v for v in crds(sc).values()))