
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

def build_tree(t, cmds):
  if cmds == []:
    return t
  else:
    cmd = cmds.pop()
    if cmd['cmd'] == 'cd':
      