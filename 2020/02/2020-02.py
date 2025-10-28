import re
inp=[ re.match(r"(\d+)-(\d+) (.): ([a-z]+)",s).groups()
      for s in open("input.txt").read().splitlines()]
print( sum(1 for a,b,c,d in inp if
        int(a) <= sum(1 for x in d if c==x) <= int(b)))
print(sum(1 for a,b,c,d in inp if
        (d[int(a)-1] == c) ^ (d[int(b)-1] == c)))
