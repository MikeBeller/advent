
def parse(s):
  ts,ds = s.splitlines()
  return list(zip(
    [int(x) for x in ts.strip().split()[1:]],
    [int(x) for x in ds.strip().split()[1:]]))

tinput = parse("""
Time:      7  15   30
Distance:  9  40  200""".strip())

print(tinput)
