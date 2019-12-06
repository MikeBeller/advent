from typing import List,Dict

class Node:
    def __init__(self, name: str):
        self.name: str = name
        self.children: List[Node] = []

def read_tree(inp: str) -> Dict[str,Node]:
    t: Dict[str,Node] = {}
    for s in inp.split():
        orbited,orbiter = s.split(")")
        if orbiter not in t:
            t[orbiter] = Node(orbiter)
        if orbited not in t:
            t[orbited] = Node(orbited)
        t[orbited].children.append(t[orbiter])
    return t

def checksum(node: Node, depth: int) -> int:
    s = depth
    for child in node.children:
        s += checksum(child, depth + 1)
    return s

def part_one(inp: str) -> int:
    t = read_tree(inp)
    r = checksum(t["COM"], 0)
    return r

def main() -> None:
    inp = open("input.txt").read()
    print(part_one(inp))

assert part_one("COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L") == 42

if __name__ == '__main__':
    main()
