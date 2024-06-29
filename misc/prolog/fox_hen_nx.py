import networkx as nx

def valid_state(fox, hen, corn, farmer):
    return not ((hen != farmer and fox == hen) or (hen != farmer and hen == corn))

def all_moves(fox, hen, corn, farmer):
    dst = 'H' if farmer == 'M' else 'M'
    if fox == farmer: yield(dst, hen, corn, dst)
    if hen == farmer: yield(fox, dst, corn, dst)
    if corn == farmer: yield(fox, hen, dst, dst)
    yield(fox, hen, corn, dst)

def node_name(fox, hen, corn, farmer):
    return fox + hen + corn + farmer

G = nx.DiGraph()
G.add_nodes_from(node_name(fox, hen, corn, farmer)
                 for fox in "HM" for hen in "HM" for corn in "HM" for farmer in "HM"
                 if valid_state(fox,hen,corn,farmer))
nx.draw(G, with_labels=True)

for S in G.nodes:
    for fox,hen,corn,farmer in all_moves(*S):
        nxt = node_name(fox, hen, corn, farmer)
        if nxt in G.nodes:
            G.add_edge(S,nxt)

for p in nx.all_shortest_paths(G, "HHHH", "MMMM"):
    print(p)