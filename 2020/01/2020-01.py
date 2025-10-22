inp = [int(s) for s in open("input.txt").read().splitlines()]
print([x*y for x in inp for y in inp if x + y == 2020][0])
print([x*y*z for x in inp for y in inp for z in inp if x + y + z == 2020][0])
