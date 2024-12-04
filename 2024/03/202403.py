import re
input = open("input.txt").read()
muls = re.findall(r'mul\(\d+,\d+\)', input)
pairs = [[int(n) for n in re.findall(r'\d+', m)] for m in muls]
print(sum(x*y for x,y in pairs))

insts = re.findall(r"mul[(]\d+,\d+[)]|do[(][)]|don't[(][)]", input)
r = 0
en = 1
for inst in insts:
  if inst.startswith("mul"):
    if en:
      a,b = [int(x) for x in inst[4:-1].split(",")]
      r += a * b
  elif inst.startswith("don't"):
    en = 0
  elif inst.startswith("do"):
    en = 1

print(r)
