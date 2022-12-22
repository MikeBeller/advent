
def parse_cmd(cstr):
  lines = cstr.splitlines()
  words = lines[0].split()
  if words[0] == 'cd':
    return {'cmd': 'cd', 'args': words[1]}
  elif words[0] == 'ls':
    items = [x.split() for x in lines[1:]]
    return {'cmd': 'ls', 'args': items}

def parse_input(input_str):
  return [parse_cmd(x) for x in input_str.split('$ ')[1:]]

tinput = parse_input(open('tinput.txt', 'r').read())

print(tinput)

def build_tree(cmds):
  cmds = list(reversed(cmds[1:]))
  tree = {}
  path = [tree]
  while cmds:
    cmd = cmds.pop()
    match cmd:
      case {'cmd': 'cd', 'args': ".."}:
        path.pop()
      case {'cmd': 'cd', 'args': d}:
        path.append(path[-1][d])
      case {'cmd': 'ls', 'args': items}:
        for item in items:
          match item:
            case ['dir', d]:
              path[-1][d] = {}
            case [sz, nm]:
              path[-1][nm] = int(sz)
  return tree

def sizes(tree):
  """create a list containing the size of
  each directory in the tree, inculding
  all subdirectories"""
  sizes = []
  for k, v in tree.items():
    if isinstance(v, dict):
      sizes.append(sizes(v))
    else:
      pass
  return sizes


def part1(cmds):
  tree = build_tree(cmds)
  sizes(tree)
  return tree

print(part1(tinput))

      