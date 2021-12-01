def part1(data):
    mx = data[0]
    c = 0
    for i in range(1,len(data)):
        v = data[i]
        if v > mx:
            c += 1
            mx = v
        else:
            mx = v
    return c

td = [ 199, 200, 208, 210, 200, 207, 240, 269, 260, 263 ]
assert part1(td) == 7

data = [int(s) for s in open("input.txt").read().splitlines()]
print("PART1:", part1(data))

def sums(data):
    for i in range(0,len(data)-2):
        yield data[i] + data[i+1] + data[i+2]

def part2(data):
    return part1(list(sums(data)))

assert part2(td) == 5

print("PART2:", part2(data))