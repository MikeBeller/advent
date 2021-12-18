from collections import defaultdict


def parse(instr):
    links = [line.split("-") for line in instr.splitlines()]
    r = defaultdict(set)
    for f, t in links:
        r[f].add(t)
        r[t].add(f)
    return r


td1 = parse("""
start-A
start-b
A-c
A-b
b-d
A-end
b-end
""".strip())

td2 = parse("""
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW""".strip())

data = parse(open("input.txt").read())


def part1(lnk):
    states = [('start',)]
    paths = set()
    while states:
        new_states = []
        for path in states:
            st = path[-1]
            if st == 'end':
                paths.add(path)
            else:
                for d in lnk[st]:
                    if not d.islower() or d not in path:
                        new_states.append(path + (d,))
        states = new_states
    return len(paths)


assert part1(td1) == 10
assert part1(td2) == 226
print("PART1:", part1(data))


def get_paths(lnk, dbl):
    assert dbl.islower()
    states = [('start',)]
    paths = set()
    while states:
        new_states = []
        for path in states:
            st = path[-1]
            if st == 'end':
                paths.add(path)
            else:
                for d in lnk[st]:
                    if not d.islower() or d not in path or (
                            d == dbl and path.count(d) == 1):
                        new_states.append(path + (d,))
        states = new_states
    return paths


def part2(lnk):
    paths = set()
    for k in lnk.keys():
        if k.islower() and k not in ['start', 'end']:
            ps = get_paths(lnk, k)
            paths.update(ps)
    return len(paths)


assert part2(td1) == 36
assert part2(td2) == 3509
print("PART2:", part2(data))
