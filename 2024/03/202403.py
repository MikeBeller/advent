import re
input = open("input.txt").read()
muls = re.findall(r'mul\(\d+,\d+\)', input)
pairs = [[int(n) for n in re.findall(r'\d+', m)] for m in muls]
print(sum(x*y for x,y in pairs))