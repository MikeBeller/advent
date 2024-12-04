m = [list(l.strip()) for l in open("input.txt").read().splitlines()]

def xmas(m, r, c, dr, dc):
  if m[r][c] != "X":
    return 0
  rs = []
  for i in range(4):
    rs.append(m[r][c])
    r += dr
    c += dc
    if r < 0 or r >= len(m) or c < 0 or c >= len(m[0]):
      break 
  word = "".join(rs)
  return 1 if word == "XMAS" else 0

p1 = sum(xmas(m, r, c, dr, dc)
  for r in range(len(m))
    for c in range(len(m[0]))
      for dr in range(-1,2)
        for dc in range(-1,2))
print(p1)
