import sys
from typing import Iterator,List,Any
from dataclasses import dataclass

class Node:
    def __init__(self) -> None:
        self.meta: List[int] = []
        self.children: List[Node] = []

def read_tree(ns: Iterator[int]) -> Node:
    node = Node()
    n_nodes = next(ns)
    n_meta = next(ns)

    for i in range(n_nodes):
        child = read_tree(ns)
        node.children.append(child)

    for i in range(n_meta):
        node.meta.append(next(ns))

    return node

def sum_meta(node: Node) -> int:
    return sum(node.meta) + sum(sum_meta(n) for n in node.children)

def sum_code(node: Node) -> int:
    return (sum(node.meta)
            if len(node.children) == 0
            else sum(sum_code(node.children[n-1])
                for n in node.meta if n >=1 and n <= len(node.children)))

def main() -> None:
    data = (int(s) for s in sys.stdin.read().split())
    tree = read_tree(data)

    ans1 = sum_meta(tree)
    print(ans1)

    ans2 = sum_code(tree)
    print(ans2)

if __name__ == '__main__':
    main()

