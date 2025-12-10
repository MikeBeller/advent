from collections import defaultdict as Ddict

def Rd(fn): return open(fn).read().strip()
def Lines(s): return s.strip().splitlines()
def Map(f,xs): return [f(x) for x in xs]

from functools import reduce
Reduce = reduce
Count = lambda f,xs: sum(bool(f(x)) for x in xs )
Filter = lambda f,xs: [x for x in xs if f(x)]
import math
Prod = math.prod
from itertools import accumulate, chain, combinations, permutations
Chain = chain
Combinations = combinations
Permutations = permutations
def Acc(func, items, start=None):
  if start:
    return list(accumulate([start]+items, func))
  else:
    return list(accumulate(items, func))

Eq = lambda a,b: a == b
Ne = lambda a,b: a != b 
Zero = lambda a: a == 0 


from re import match
Match = match

def Parse(fmt, line, sep=None, rx=None):
  if rx:
    fields = match(rx,line).groups()
  else:
    fields = line.strip().split(sep)
  row = []
  for i,fmt in enumerate(fmt):
    fld = fields[i]
    match fmt:
      case 'x':
        continue 
      case 's':
        row.append(fld)
      case 'i':
        row.append(int(fld))
      case 'f':
        row.append(float(fld))
      case 'S':
        row.extend(fields[i:])
      case 'I':
        row.extend(int(f) for f in fields[i:])
      case 'F':
        row.extend(float(f) for f in fields[i:])
  return(tuple(row))

def fParse(fname, fmt, sep=None, rx=None):
  return [Parse(fmt, line, sep, rx) for line in Lines(Rd(fname))]

