
tds = """
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)"""

def read_data(inp):
    rs = []
    for line in inp.strip().splitlines():
        line = line.rstrip(")")
        line = line.replace(",","")
        ings_s, algs_s = line.split("(contains ")
        rs.append((set(ings_s.split()), set(algs_s.split())))
    return rs

def possible_assignments(rules):
    all_algs = set.union(*[algs for (ings,algs) in rules])
    can_be = {}
    for alg in all_algs:
        can_be[alg] = set.intersection(*[ings for (ings,algs) in rules if alg in algs])
    return can_be

def part1(rules):
    can_be = possible_assignments(rules)
    all_used_ings = set.union(*can_be.values())
    sm = 0
    for (ings,algs) in rules:
        sm += sum(1 for i in ings if i not in all_used_ings)
    return sm

test_rules = read_data(tds)
assert part1(test_rules) == 5

inp = open("input.txt").read()
rules = read_data(inp)
print("PART1:", part1(rules))

