p = [(int(c),int(r)) for c,r in
 [s.split(",") for s in open("09.txt").read().splitlines()]]
m = max((abs(p[j][0]-p[i][0])+1)*(abs(p[j][1]-p[i][1])+1)
  for i in range(len(p)) for j in range(len(p)))
print(m)
