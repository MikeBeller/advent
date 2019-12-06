from typing import List,Dict

class Node:
    def __init__(self, name: str, parent:str=""):
        self.name: str = name
        self.parent: str = parent
        self.children: List[Node] = []

def read_tree(inp: str) -> Dict[str,Node]:
    t: Dict[str,Node] = {}
    for s in inp.split():
        orbited,orbiter = s.split(")")
        if orbiter not in t:
            t[orbiter] = Node(orbiter, orbited)
        else:
            if t[orbiter].parent == "":
                t[orbiter].parent = orbited
        if orbited not in t:
            t[orbited] = Node(orbited)
        t[orbited].children.append(t[orbiter])
    return t

def checksum(node: Node, depth: int) -> int:
    s = depth
    for child in node.children:
        s += checksum(child, depth + 1)
    return s

def path_to_root(t: Dict[str,Node], nnm: str) -> List[str]:
    r: List[str] = []
    n = t[nnm]
    while n.parent != "":
        r.append(n.parent)
        n = t[n.parent]
    return r

def part_one(inp: str) -> int:
    t = read_tree(inp)
    r = checksum(t["COM"], 0)
    return r

def part_two(inp: str) -> int:
    t = read_tree(inp)
    a = path_to_root(t, "YOU")
    b = path_to_root(t, "SAN")
    while len(a) > 0 and len(b) > 0 and a[-1] == b[-1]:
        a.pop()
        b.pop()
    return len(a) + len(b)

def main() -> None:
    inp = open("input.txt").read()
    print("PART 1:", part_one(inp))

    print("PART 2:", part_two(inp))

assert part_one("COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L") == 42
assert part_two("COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L K)YOU I)SAN") == 4

if __name__ == '__main__':
    main()
