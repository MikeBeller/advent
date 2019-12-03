import sys
from typing import List,Tuple,DefaultDict,TextIO
from collections import defaultdict

def parse_trail(line: str) -> List[Tuple[str,int]]:
    return [(s[0],int(s[1:])) for s in line.strip().split(",")]

def read_data(f: TextIO) -> List[List[Tuple[str,int]]]:
    return [parse_trail(line) for line in f]

assert parse_trail("R52,U37,D20\n") == [('R',52), ('U', 37), ('D', 20)]

def part_one(data: List[List[Tuple[str,int]]]) -> int:
    """Find intersection of two trails.  Strategy is to use a dictionary
    to represent points in the grid, and "walk" the trails.  First trail
    will put 1 everywhere it goes, and second will put 2.  Then look for
    points (hash table locations) which have value 3."""

    assert len(data) == 2
    g : DefaultDict[Tuple[int,int],int] = defaultdict(int)
    for (k,trail) in enumerate(data):
        x,y = 0,0
        v = 2 ** k
        for (d,n) in trail:
            for i in range(n):
                if d == 'R':
                    x += 1
                elif d == 'L':
                    x -= 1
                elif d == 'U':
                    y += 1
                elif d == 'D':
                    y -= 1
                g[(x,y)] |= v

    crosses : List[Tuple[int,int]] = [k for (k,v) in g.items() if v == 3]
    
    return min((abs(x)+abs(y)) for x,y in crosses)

def part_two(data: List[List[Tuple[str,int]]]) -> int:
    """Similar to part_one, but now each grid point will have a pair
    of integers representing the step number in the trail of each wire.
    Look for pairs where both step numbers are nonzero, and find the
    minimum sum"""

    assert len(data) == 2
    g : DefaultDict[Tuple[int,int],List[int]] = defaultdict(lambda: [0,0])
    for (k,trail) in enumerate(data):
        x,y = 0,0
        s = 0 # step number
        for (d,n) in trail:
            for i in range(n):
                if d == 'R':
                    x += 1
                elif d == 'L':
                    x -= 1
                elif d == 'U':
                    y += 1
                elif d == 'D':
                    y -= 1
                s += 1
                if g[(x,y)][k] == 0:
                    g[(x,y)][k] = s

    cross_steps : List[List[int]] = [v for (k,v) in g.items() if v[0] != 0 and v[1] != 0]
    ans = min((abs(s)+abs(t)) for s,t in cross_steps)
    return ans

def main(fpath: str) -> None:
    with open(fpath) as infile:
        data = read_data(infile)
    ans1 = part_one(data)
    print(ans1)

    ans2 = part_two(data)
    print(ans2)

def test() -> None:
    t1 = "R8,U5,L5,D3"
    t2 = "U7,R6,D4,L4"
    assert part_one([parse_trail(t1), parse_trail(t2)]) == 6
    assert part_two([parse_trail(t1), parse_trail(t2)]) == 30

    t1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72"
    t2 = "U62,R66,U55,R34,D71,R55,D58,R83"
    assert part_one([parse_trail(t1), parse_trail(t2)]) == 159
    assert part_two([parse_trail(t1), parse_trail(t2)]) == 610

    t1 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"
    t2 = "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    assert part_one([parse_trail(t1), parse_trail(t2)]) == 135
    assert part_two([parse_trail(t1), parse_trail(t2)]) == 410

if __name__ == '__main__':
    if len(sys.argv) == 2:
        main(sys.argv[1])
    else:
        test()



