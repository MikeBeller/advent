
def mod(x, m):
    r = x % m
    while r < 0:
        r += m
    return r

def move(cs, c):
    print("MOVE:", cs, c)
    l = len(cs)

    # select 3 cups
    mcs = cs[(c+1) % l], cs[(c+2) % l], cs[(c+3) % l]
    print("Picking up:", mcs)

    # destination cup:
    # find cup with label equal to "current cup" - 1
    # (if it's a selected cup keep subtracting one and
    # also wrap around from 1 to 9)
    dc = cs[c] - 1
    if dc < 1: dc = 9
    while dc in mcs:
        dc -= 1
        if dc < 1: dc = 9
    di = cs.index(dc)
    print(f"Dest cup is label {dc} index {di}")

    # place the cups clockwise of the "destination cup"
    # (don't forget you have 3 "holes" in the list
    # which you have to collapse)
    mv = mod(di - c - 4 + 1, l)
    print(f"need to move all left 3 from {c+4} to {di}")
    for i in range(mv):
        cs[(c+1 + i)%l] = cs[(c+4 +i)%l] 
    cs[mod(di-3+1,l)],cs[mod(di-3+2,l)],cs[mod(di-3+3,l)] = mcs
    print("New order is:", cs, "current:", (c+1)%l)
    print()

    return cs, (c+1)%l


move([3, 8, 9, 1, 2, 5, 4, 6, 7], 0)

def part1(cs, n):
    c = 0
    for i in range(n):
        cs,c = move(cs, c)
    return "".join(str(x) for x in cs)

print(part1([3, 8, 9, 1, 2, 5, 4, 6, 7], 10))
