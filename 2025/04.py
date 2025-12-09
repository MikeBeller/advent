inp = open("04.txt").read().splitlines()
nr,nc = len(inp), len(inp[0])
get = lambda m,r,c: (0 if r < 0 or r >= nr
    or c < 0 or c >= nc
    or m[r][c] == "." else 1)
count = lambda m,r,c: sum(
    get(m,r+dr,c+dc)
      for dr in [-1,0,1]
      for dc in [-1,0,1]
      if not (dr == 0 and dc == 0))
      
def reachable(m):
    return [(r,c) for r in range(nr)
           for c in range(nc)
             if get(m,r,c) and count(m,r,c) < 4]
print(len(reachable(inp)))

def part2(inp):
    m = [list(row) for row in inp]
    tot = 0
    while ps := reachable(m):
        for r,c in ps:
            m[r][c] = "."
            tot += 1
    return tot

print(part2(inp))
