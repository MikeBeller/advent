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

def sizes(tree, szs):
  if type(tree) == int:
    return tree
  else:
    sz = sum(sizes(v, szs) for k,v in tree.items())
    szs.append(sz)
    return sz

def part1(cmds):
  nodes = find(cmds)
  tree = build_tree(nodes)
  szs = []
  sizes(tree, szs)
  return sum(s for s in szs if s < 100000)

assert part1(tinput) == 95437

print(part1(input))

def part2(cmds):
  nodes = find(cmds)
  tree = build_tree(nodes)
  szs = []
  sizes(tree, szs)
  szs.sort(reverse=True)
  needed = 30000000 - (70000000 - szs[0])
  big_enough = [x for x in szs if x >= needed]
  return big_enough[-1]

assert part2(tinput) == 24933642
print(part2(input))