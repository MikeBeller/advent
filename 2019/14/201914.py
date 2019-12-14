from collections import namedtuple,defaultdict
from typing import List,Tuple,Dict,NamedTuple,DefaultDict

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
    return data

def part_one(data: List[Tuple[Pair,List[Pair]]]) -> int:
    d: Dict[str,Tuple[int,List[Pair]]] = {}
    for (to, froms) in data:
        assert to not in d
        d[to.nm] = (to.q, froms)

    assert d['FUEL'][0] == 1
    needs: DefaultDict[str,int] = defaultdict(int)
    needs['FUEL'] = 1

    while True:
        if 'ORE' in needs and needs['ORE'] > 0 and all(v <= 0 for k,v in needs.items() if k != 'ORE'):
                break
        for ndn,ndq in list(needs.items()): # list so we can mod the dict
            if ndn == 'ORE' or ndq < 0:
                continue
            if ndq == 0:
                del needs[ndn]
                continue

            print("TRYING", ndn, ndq)
            mkq,kids = d[ndn]
            for k in kids:
                print("KID", k)
                needs[k.nm] += k.q
            needs[ndn] -= mkq
            print("DECREMENTED", ndn, "to", needs[ndn])
        print(needs)

    print('DONE')
    print(needs)
    return needs['ORE']

def test_part_one(s: str) -> int:
    return part_one(read_data(s))

assert test_part_one("""10 ORE => 10 A\n1 ORE => 1 B\n7 A, 1 B => 1 C\n7 A, 1 C => 1 D\n7 A, 1 D => 1 E\n7 A, 1 E => 1 FUEL""") == 31

assert test_part_one("""9 ORE => 2 A
8 ORE => 3 B
7 ORE => 5 C
3 A, 4 B => 1 AB
5 B, 7 C => 1 BC
4 C, 1 A => 1 CA
2 AB, 3 BC, 4 CA => 1 FUEL""") == 165
    
assert test_part_one("""157 ORE => 5 NZVS
165 ORE => 6 DCFZ
44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
179 ORE => 7 PSHF
177 ORE => 5 HKGWZ
7 DCFZ, 7 PSHF => 2 XJWVT
165 ORE => 2 GPVTF
3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT""") == 13312

assert test_part_one("""2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
17 NVRVD, 3 JNWZP => 8 VPVL
53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
22 VJHF, 37 MNCFX => 5 FWMGM
139 ORE => 4 NVRVD
144 ORE => 7 JNWZP
5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
145 ORE => 6 MNCFX
1 NVRVD => 8 CXFTF
1 VJHF, 6 MNCFX => 4 RFSQX
176 ORE => 6 VJHF""") == 180697

def main() -> None:
    data = read_data(open("input.txt").read())
    ans1 = part_one(data)
    print("PART 1", ans1)

#main()

