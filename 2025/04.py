inp = open("04.txt").read().splitlines()
nr,nc = len(inp), len(inp[0])
get = lambda r,c: 0 if r < 0 or r >= nr or c < 0 or c >= nc or inp[r][c] == "." else 1
count = lambda r,c: sum(
    get(r+dr,c+dc)
      for dr in [-1,0,1]
      for dc in [-1,0,1]
      if not (dr == 0 and dc == 0))
print(
    sum(
        1 for r in range(nr)
           for c in range(nc)
             if count(r,c) < 4))
