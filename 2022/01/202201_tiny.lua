require 'pl'
stringx.import()
data = io.input("input.txt"):read('*a'):split("\n\n"):map(
  function (g) return seq.sum(g:splitlines():map(tonumber)) end)
a,b = seq.minmax(data)
print(b)
data:sort()
a,b = seq.sum(data:slice(-3,-1))
print(a)