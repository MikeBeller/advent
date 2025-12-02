def Rd(fn): return open(fn).read().strip()
def Ln(s): return s.strip().splitlines()
def M(f,xs): return [f(x) for x in xs]
from functools import reduce
R = reduce
from itertools import accumulate
A = accumulate
Eq = lambda a,b: a == b
Ne = lambda a,b: a != b 
Zero = lambda a: a == 0 


from re import match
def Parse(fmt, line, sep=None, rx=None):
  if rx:
    fields = match(rx,line).groups()
  else:
    fields = line.split(sep)
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
