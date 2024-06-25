def lines(fpath):
  with open(fpath) as infile:
    return infile.read().splitlines()

def parse(fmt, line, sep=None):
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

assert parse("sixf", "foo 7 gg 33.25") == ('foo', 7, 33.25)
assert parse("sixf", "boof 9 xx 8") == ('boof', 9, 8.0)
assert parse("xI", "boof 23 34 54") == (23, 34, 54)