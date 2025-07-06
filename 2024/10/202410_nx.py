import networkx as nx

input = open("input.txt").read()
heads = set()
ends = set()

# Add nodes to graph, noting the trail heads and trail ends
G = nx.DiGraph()
for r,line in enumerate(input.splitlines()):
  for c, ch in enumerate(line):
    ht=int(ch)
    G.add_node((r,c), ht=ht)
    if ht == 0:
      heads.add((r,c))
    elif ht == 9:
      ends.add((r,c))

# Connect nodes that have height difference of 1
for n in G.nodes:
  r,c = n
  for dr,dc in [(-1,0),(1,0),(0,-1),(0,1)]:
    neighbor = (r+dr, c+dc)
    if neighbor in G and G.nodes[neighbor]["ht"] - G.nodes[n]["ht"] == 1:
      G.add_edge(n,neighbor)

# part1 -- sum of (number of end nodes you can reach from each head node)
p1 = sum(
  1 
    for hd in heads
      for n in nx.descendants(G,hd)
       if n in ends)
print(p1)

# part2 -- sum of (number of paths to an end node from each head node)
from functools import lru_cache
@lru_cache(maxsize=None)
def count_paths(u):
    if u in ends:
        return 1
    return sum(count_paths(v) for v in G.successors(u))

p2 = sum(count_paths(h) for h in heads)
print(p2)
