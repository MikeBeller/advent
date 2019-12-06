from typing import List,Dict

class Node:
    def __init__(self, name):
        self.name : str = name
        self.n_orbits : int = 0
        self.children : List[Node] = []

def read_tree(inp: str) -> Dict[str,Node]:
    #t: Dict[str,Node] = {"COM": Node("COM")}
    t = {"COM": Node("COM")}
    for s in inp.split():
        orbited,orbiter = s.split(")")
        if orbiter not in t:
            t[orbiter] = Node(orbiter)
        t[orbited].children.append(t[orbiter])
    return t

def checksum(t: Dict[str,Node]) -> int:
    pass



