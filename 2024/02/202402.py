from numpy import *

rs = [fromstring(ln, sep=" ", dtype=int) for ln in open("input.txt").readlines()]

def valid(r):
  dr = diff(r)
  return (all(dr >= 1) & all(dr <=3)) | (all(dr <= -1) & all(dr >= -3))
  
print(len([r for r in rs if valid(r)]))

hacked_rows = lambda row: [delete(row,i) for i in range(len(row))]
any_valid = lambda row: any([valid(r) for r in hacked_rows(row)])
print(len([r for r in rs if any_valid(r)]))