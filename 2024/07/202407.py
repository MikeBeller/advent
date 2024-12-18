def parse(s):
  eqs = []
  for line in s.strip().splitlines():
    first,rest = line.split(":")
    t = int(first)
    rs = [int(s) for s in rest.strip().split()]
    eqs.append((t, rs))
  return eqs


    