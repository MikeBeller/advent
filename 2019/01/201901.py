import sys

data = [int(s) for s in sys.stdin.read().splitlines()]
ans1 = sum(m//3 - 2 for m in data)
print(ans1)

def fuel_r(m):
    f = m // 3 - 2
    if f <= 0:
        return 0
    return f + fuel_r(f)

ans2 = sum(fuel_r(m) for m in data)
print(ans2)

