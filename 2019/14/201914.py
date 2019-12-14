from collections import namedtuple
from typing import List,Tuple,Dict,NamedTuple

class Pair(NamedTuple):
    nm: str
    q: int

def split_pair(s: str) -> Pair:
    l,r = s.strip().split(" ")
    return Pair(r.strip(), int(l.strip()))

def read_data(instr: str) -> List[Tuple[Pair,List[Pair]]]:
    #data: List[Tuple[Pair,List[Pair]]] = []
    data = []
    for line in instr.splitlines():
        l,r = line.strip().split("=>")
        to = split_pair(r)
        data.append((to, [split_pair(ps) for ps in l.split(",")]))
    print(data)
    return data

def part_one(data: List[Tuple[Pair,List[Pair]]]) -> int:
    d: Dict[str,Tuple[int,List[Pair]]] = {}
    for (to, froms) in data:
        assert to not in d
        print("SET", to.nm, "to", to.q, froms)
        d[to.nm] = (to.q, froms)

    assert d['FUEL'][0] == 1
    needs: DefaultDict[str,int] = defaultdict(int)
    needs['FUEL'] = 1
    while True:
        if len(needs) == 1 and 'ORE' in needs:
            break

    
    return r

def test_part_one() -> None:
    s = """10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL"""
    
    #s = open("input.txt").read()
    data = read_data(s)

    ans1 = part_one(data)
    assert ans1 == 165

def main() -> None:
    test_part_one()

main()

