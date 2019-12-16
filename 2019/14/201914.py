from typing import List,Tuple,Dict,NamedTuple
import math

class Pair(NamedTuple):
    nm: str
    q: int

class Formula(NamedTuple):
    out: Pair
    kids: List[Pair]

def split_pair(s: str) -> Pair:
    l,r = s.strip().split(" ")
    return Pair(r.strip(), int(l.strip()))

def read_data(instr: str) -> Dict[str,Formula]:
    formulas: Dict[str,Formula] = {}
    for line in instr.splitlines():
        l,r = line.strip().split("=>")
        out = split_pair(r)
        formulas[out.nm] = Formula(out, [split_pair(ps) for ps in l.split(",")])
    return formulas

def reaction_engine(formulas: Dict[str,Formula], chamber: Dict[str,int]) -> None:
    """One pass of reaction engine"""
    for needed_chem in list(chamber.keys()): # list so we can mod the dict during the loop
        quantity = chamber[needed_chem]
        if needed_chem == 'ORE' or quantity > 0:
            continue
        if quantity == 0:
            del chamber[needed_chem]
            continue

        f = formulas[needed_chem]
        for k in f.kids:
            chamber[k.nm] = chamber.get(k.nm, 0) - k.q
        chamber[needed_chem] += f.out.q
    return

def part_one(formulas: Dict[str,Formula]) -> int:
    chamber: Dict[str,int] = {'FUEL': -1}
    while True:
        reaction_engine(formulas, chamber)
        if 'ORE' in chamber and chamber['ORE'] < 0 and all(v >= 0 for k,v in chamber.items() if k != 'ORE'):
            break
    return -chamber['ORE']

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

assert test_part_one("""171 ORE => 8 CNZTR
7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
114 ORE => 4 BHXH
14 VRPVC => 6 BMBT
6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
5 BMBT => 4 WPTQ
189 ORE => 9 KTJDG
1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
12 VRPVC, 27 CNZTR => 2 XDBXC
15 KTJDG, 12 BHXH => 5 XCVML
3 BHXH, 2 VRPVC => 7 MZWV
121 ORE => 7 VRPVC
7 XCVML => 6 RJRHP
5 BHXH, 4 VRPVC => 5 LTCX""") == 2210736

def test_part_two() -> None:
    test1 = """10 ORE => 10 A\n1 ORE => 1 B\n7 A, 1 B => 1 C\n7 A, 1 C => 1 D\n7 A, 1 D => 1 E\n7 A, 1 E => 1 FUEL"""
    test2 = """9 ORE => 2 A
8 ORE => 3 B
7 ORE => 5 C
3 A, 4 B => 1 AB
5 B, 7 C => 1 BC
4 C, 1 A => 1 CA
2 AB, 3 BC, 4 CA => 1 FUEL"""

    test3 = """157 ORE => 5 NZVS
165 ORE => 6 DCFZ
44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
179 ORE => 7 PSHF
177 ORE => 5 HKGWZ
7 DCFZ, 7 PSHF => 2 XJWVT
165 ORE => 2 GPVTF
3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT"""  # 13312

    test5 = """171 ORE => 8 CNZTR
7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
114 ORE => 4 BHXH
14 VRPVC => 6 BMBT
6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
5 BMBT => 4 WPTQ
189 ORE => 9 KTJDG
1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
12 VRPVC, 27 CNZTR => 2 XDBXC
15 KTJDG, 12 BHXH => 5 XCVML
3 BHXH, 2 VRPVC => 7 MZWV
121 ORE => 7 VRPVC
7 XCVML => 6 RJRHP
5 BHXH, 4 VRPVC => 5 LTCX""" # 460664

    formulas = read_data(test3)
    chamber: Dict[str,int] = {'FUEL': -1}
    while True:
        reaction_engine(formulas, chamber)
        if 'ORE' in chamber and chamber['ORE'] < 0 and all(v >= 0 for k,v in chamber.items() if k != 'ORE'):
            break

    mpy = int(1000000000000 // -chamber['ORE'] * 0.9999)
    for k in chamber.keys():
        chamber[k] *= mpy
    fuel = mpy
    print("Starting with fuel =", mpy)

    print(chamber)
    while chamber['ORE'] > -1000000000000:
        oldfuel = fuel; oldore = chamber['ORE']
        if fuel % 1000 == 0:
            print(chamber['ORE'], fuel)
        chamber['FUEL'] = -1
        while True:
            reaction_engine(formulas, chamber)
            if all(v >= 0 for k,v in chamber.items() if k != 'ORE'):
                break
        fuel += 1

    print(fuel, chamber, "OLD", oldfuel, oldore)


def main() -> None:
    data = read_data(open("input.txt").read())
    ans1 = part_one(data)
    print("PART 1", ans1)
    test_part_two()

main()

