class Node:
    def __init__(self, lab, nxt=None):
        self.label = lab
        self.nxt = nxt

def list_items(ls):
    r = []
    if ls == None:
        return r
    p = ls
    while p is not None:
        r.append(p.label)
        p = p.nxt
        if p == ls:
            break
    return r

def move(nodes, current):
    # pick up 3 items clockwise of current
    move_node_list = current.nxt
    current.nxt = move_node_list.nxt.nxt.nxt
    move_node_list.nxt.nxt.nxt = None
    move_set = set(list_items(move_node_list))

    # find the next label down (wrapping 1->9) which
    # is not in the set of nodes being moved
    dc = current.label - 1
    if dc < 1: dc = len(nodes)
    while dc in move_set:
        dc -= 1
        if dc < 1: dc = len(nodes)

    # place the cups clockwise of the "destination cup"
    dest_node = nodes[dc]
    el = dest_node.nxt
    dest_node.nxt = move_node_list
    move_node_list.nxt.nxt.nxt = el

    # new current is one node clockwise of the current
    return current.nxt

def part1(cs, nmoves):
    nodes = {}
    ls = p = Node(cs[0], None)
    nodes[cs[0]] = p
    for i in range(1,len(cs)):
        p.nxt = Node(cs[i], None)
        nodes[cs[i]] = p.nxt
        p = p.nxt
    p.nxt = ls  # circular

    current = ls
    for i in range(nmoves):
        current = move(nodes, current)

    return list_items(nodes[1].nxt)[:-1]

#assert part1([3, 8, 9, 1, 2, 5, 4, 6, 7], 10) == [9, 2, 6, 5, 8, 3, 7, 4]
#assert part1([3, 8, 9, 1, 2, 5, 4, 6, 7], 100) == [6, 7, 3, 8, 4, 5, 2, 9]

#print("PART1:", part1([2, 1, 9, 7, 4, 8, 3, 6, 5], 100))

def part2(cs, nmoves):
    nodes = {}
    ls = p = Node(cs[0], None)
    nodes[cs[0]] = p
    for i in range(1,len(cs)):
        p.nxt = Node(cs[i], None)
        nodes[cs[i]] = p.nxt
        p = p.nxt
    for i in range(10, 1000001):
        p.nxt = Node(i, None)
        nodes[i] = p.nxt
        p = p.nxt
    p.nxt = ls  # circular

    its = list_items(ls) 
    current = ls
    for i in range(nmoves):
        current = move(nodes, current)

    l1 = nodes[1].nxt.label
    l2 = nodes[1].nxt.nxt.label

    return l1 * l2

#assert part2([3, 8, 9, 1, 2, 5, 4, 6, 7], 10000000) == 149245887792
print("PART2:", part2([2, 1, 9, 7, 4, 8, 3, 6, 5], 10000000))
