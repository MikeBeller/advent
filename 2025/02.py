inp = [[int(s) for s in p.split("-")]
       for p in open("02.txt").read().split(",")]

def fake(n):
    s = str(n)
    if len(s) % 2 == 1: return False
    h = len(s)//2
    return s[:h] == s[h:]

assert not fake(101)
assert fake(6464)

def part1(inp):
    c = 0
    for b,e in inp:
        assert b < e
        for i in range(b,e+1):
            if fake(i):
                c += i
    return c

print(part1(inp))
