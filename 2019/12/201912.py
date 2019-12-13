import numpy as np
from io import StringIO

test1 = """<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>
"""

def read_data(s):
    s = s.replace("x=","")
    s = s.replace("y=","")
    s = s.replace("z=","")
    s = s.replace("<","")
    s = s.replace(">","")
    s = s.replace(",","")
    inp = StringIO(s)

    return np.loadtxt(inp, dtype=np.int64)

pos = read_data(test1)
nr = len(pos)
vel = np.zeros(pos.shape, dtype=np.int64)

def gravity(pos, vel):
    for r in range(nr):
        for c in range(3):
            t = vel[r,c] + np.sum(pos[:,c] > pos[r,c]) - sum(pos[:,c] < pos[r,c])
            vel[r,c] = t

def velocity(pos, vel):
    pos += vel

def energy(pos, vel):
    return np.sum(np.apply_along_axis(np.sum, 1, np.abs(pos)) * np.apply_along_axis(np.sum, 1, np.abs(vel)))

def step(pos, vel):
    gravity(pos, vel)
    velocity(pos, vel)

def test_gravity():
    pos = np.array([[1, 0, 2], [2, -10, -7], [4, -8, 8], [3, 5, -1]])
    vel = np.zeros(pos.shape, dtype=np.int64)
    gravity(pos, vel)
    assert np.all(np.array([[3, -1, -1], [1, 3, 3], [-3, 1, -3], [-1, -3, 1]]) == vel)

def run(pos, nsteps):
    vel = np.zeros(pos.shape, dtype=np.int64)
    for i in range(nsteps):
        step(pos, vel)
    return energy(pos, vel)

def run_to_repeat(pos):
    vel = np.zeros(pos.shape, dtype=np.int64)
    ns = 0
    ps = {}
    while True:
        step(pos, vel)
        pss = str(pos)
        vls = str(vel)
        if (pss,vls) in ps:
            break
        ps[(pss,vls)] = True
        ns += 1
        if ns % 1000 == 0:
            print("steps:", ns)
    return ns

def test_energy():
    pos = np.array([[-1, 0, 2], [2, -10, -7], [4, -8, 8], [3, 5, -1]])
    en = run(pos, 10)
    assert en == 179

test_gravity()
test_energy()

def part_one():
    pos = read_data(open("input.txt").read())
    ans = run(pos, 1000)
    print(ans)

def part_two():
    pos = read_data(open("input.txt").read())
    ans = run_to_repeat(pos)
    print(ans)

def test_part_two():
    pos = read_data(test1)
    r = run_to_repeat(pos)
    assert r == 2772

def main():
    part_one()
    test_part_two()
    part_two()

main()

