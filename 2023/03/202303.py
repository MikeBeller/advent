from advent import *
from collections import defaultdict
digits = "0123456789"
tinput = lines("tinput.txt")

def locs(input):
  data = defaultdict(dict)
  number = []
  for r,line in enumerate(input):
    for c,ch in enumerate(line):
      if number and ch not in digits:
        number = []
      if ch == '.': continue 
      if ch in digits:
        data[r][c] = ('num', ch, number)
      else:
        data[r][c] = ('sym', ch, None)
  return data    
      
def part1(input):
  nr = len(input)
  nc = len(input[0])
  data = locs(input)
  found_nums = set()
  for r,row in data.items():
    for c,item in data[r].items():
      ty,ch,nm = item
      if ty == 'sym':
        for ri in range(r-1,r+2):
          for ci in range(c-1, c+2):
            if ri in data and ci in data[ri]:
              item = data[ri][ci]
              if item[0] == 'num':
                print(data[ri][ci])

        
      
  