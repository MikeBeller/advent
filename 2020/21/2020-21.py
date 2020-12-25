
tds = """
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)"""

# need to write union/intersection for circuitpython
# where set.union and set.intersection only take 2 arguments
# otherwise these can be written set.union(*[some sequence])
def union(xs):
    r = set()
    for x in xs:
        r = r.union(x)
    return r

def intersection(xs):
    r = set()
    for i,x in enumerate(xs):
        r = x if i == 0 else r.intersection(x)
    return r

def read_data(infile):
    rs = []
    for line in infile:
        line = line.strip().rstrip(")")
        line = line.replace(",","")
        ings_s, algs_s = line.split("(contains ")
        rs.append((set(ings_s.split()), set(algs_s.split())))
    return rs

def possible_assignments(rules):
    all_algs = union(algs for (ings,algs) in rules)
    can_be = {}
    for alg in all_algs:
        can_be[alg] = intersection(ings for (ings,algs) in rules if alg in algs)
    return can_be

def part1(rules):
    can_be = possible_assignments(rules)
    all_used_ings = union(can_be.values())
    sm = 0
    for (ings,algs) in rules:
        sm += sum(1 for i in ings if i not in all_used_ings)
    return sm

test_rules = read_data(tds.strip().splitlines())
assert part1(test_rules) == 5

with open("input.txt") as infile:
    rules = read_data(infile)
#rules = read_data(inp)
print("PART1:", part1(rules))
#gc.collect()

# immutable maps
def lookup(m, k):
    while m != None:
        (car,cdr) = m
        if car[0] == k:
            return car[1]
        m = cdr
    return None

def solve(rs, i, m):
    if i >= len(rs):
        return True, m

    (alg,ings) = rs[i]
    for ing in ings:
        if lookup(m, ing):
            continue

        ok,m2 = solve(rs, i+1, ((ing,alg), m))
        if ok:
            return True, m2
    return False, m

def part2(rules):
    rs = list(possible_assignments(rules).items())
    m = None
    ok, m = solve(rs, 0, m)
    assert ok
    # reverse m into a dict
    rm = {}
    while m != None:
        car,cdr = m
        rm[car[1]] = car[0]
        m = cdr
    return ",".join(rm[k] for k in sorted(rm.keys()))

assert part2(test_rules) == "mxmxvkd,sqjhc,fvjkl"

print("PART2:", part2(rules))
