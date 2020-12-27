

def read_data(inp):
    r = ([],[])
    p = None
    for line in inp:
        if line.startswith("Player"):
            p = int(line.strip().split()[1].replace(":",""))-1
            continue
        if line == "": continue
        r[p].append(int(line.strip()))
    return r

tds = """
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10""".strip().splitlines()

def part1(data):
    xs,ys = data
    while len(xs) > 0 and len(ys) > 0:
        x = xs.pop(0)
        y = ys.pop(0)
        if x > y:
            xs.extend([x,y])
        else:
            ys.extend([y,x])
    #print(xs,ys)
    wins = xs if len(xs) > 0 else ys
    return sum(((i+1) * v) for (i,v) in enumerate(reversed(wins)))

td = read_data(tds)
assert part1(td) == 306

data = read_data(open("input.txt").read().strip().splitlines())
print("PART1:", part1(data))

