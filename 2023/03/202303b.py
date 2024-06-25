from advent import *
from itertools import groupby
from math import dist
tinput = lines("tinput.txt") 
input = lines("input.txt")

def find_nums_in_row(row):
  itr = enumerate(row)
  return [list(v) for k,v in
    groupby(itr, key=lambda t: t[1].isnumeric()) if k]
    

def find_nums(data):
  nums = {}
  for r,row in enumerate(data):
    for num in find_nums_in_row(row):
      n = int("".join(dig for c,dig in num))
      r1,c1 = r,num[0][0]
      nums.update({(r,c):(r1,c1,n) for c,dig in num})
  return nums

def find_syms(data):
  syms = {}
  for r,row in enumerate(data):
    for c,ch in enumerate(row):
      if ch != "." and not ch.isnumeric():
        syms[r,c] = ch
  return syms

def part1(data):
  parts = set()
  nums = find_nums(data)
  syms = find_syms(data)
  for p1 in syms:
    for p2 in nums:
      if dist(p1,p2) < 2:
        parts.add(nums[p2])
  return sum(p[2] for p in parts)

assert part1(tinput) == 4361
print(part1(input))

def part2(data):
  nums = find_nums(data)
  syms = find_syms(data)
  sm = 0
  for p1,sym in syms.items():
    nms = set()
    if sym != "*": continue 
    for p2,num in nums.items():
      if dist(p1,p2) < 2:
        nms.add(num)
    if len(nms) == 2:
      a,b = nms
      sm += a[2] *b[2]
  return sm

assert part2(tinput) == 467835
print(part2(input))
