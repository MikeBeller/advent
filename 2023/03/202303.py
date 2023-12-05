from advent import *
from collections import defaultdict

tinput = lines("tinput.txt") 
input = lines("input.txt")

def touching_symbol(data,r,c):
  nr,nc = len(data),len(data[0])
  for dr in range(max(r-1,0),min(r+2,nr)):
    for dc in range(max(c-1,0),min(c+2,nc)):
      ch = data[dr][dc]
      if not ch.isnumeric() and ch != ".":
        return True
  return False
      
def part1(data):
  sm = 0
  for r,row in enumerate(data):
    itr = enumerate(row)
    for c,ch in itr:
      v = 0
      include = False
      while ch.isnumeric():
        if touching_symbol(data,r, c):
          include = True
        v = 10 * v + int(ch)
        if c == len(row)-1:
          break
        c,ch = next(itr)
      if include:
        print(v)
        sm += v
  return sm
  
print(part1(input))