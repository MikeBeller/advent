def lines(fpath):
  with open(fpath) as infile:
    return infile.read().splitlines()

def ints(strs):
  return [int(s) for s in strs.strip()]

def rows(strs, format, sep=None):
  rows = []
  for line in strs:
    row = []
    fields = line.split(sep)
    for i,fmt in enumerate(format):
      if i >= len(fields):
        break
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
    rows.append(tuple(row))
  return rows

assert rows(["foo 7 gg 33.25", "boof 9 xx 8"], "sixf") == [('foo', 7, 33.25), ('boof', 9, 8.0)]
    
  