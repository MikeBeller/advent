
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
input = parse_input(open('input.txt', 'r').read())

def find(cmds):
  cmds = list(reversed(cmds))
  nodes = []
  path = []
  while cmds:
    cmd = cmds.pop()
    match cmd:
      case {'cmd': 'cd', 'args': ".."}:
        path.pop()
      case {'cmd': 'cd', 'args': d}:
        path.append(d)
      case {'cmd': 'ls', 'args': items}:
        tsz = 0
        for item in items:
          match item:
            case ['dir', d]:
              pass
            case [sz, nm]:
              tsz += int(sz)
        nodes.append((tuple(path), tsz))
  return nodes

def build_tree(nodes):
  tree = {}
  for path,val in nodes:
    t = tree
    for p in path:
      t.setdefault(p, {})
      t = t[p]
    t['_size'] = t.get('_size', 0) + val
  return tree

def sizes(tree):
  print(tree, list(tree.items()))
  tree['_size'] = sum(sizes(v) for k,v in tree.items() if k!='_size')

def part1(cmds):
  nodes = find(cmds)
  tree = build_tree(nodes)
  print(tree)
  sizes(tree)
  print(tree)
  #return sum(s for s in sz if s < 100000)

r = part1(tinput)




      