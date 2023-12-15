require 'pl'
stringx.import()
function digs(s) return List(s:gmatch("%d")) end
input = file.read("input.txt"):splitlines()
ans = seq(input:map(digs)
  :map(function (ls) return ls[1]*10 + ls[#ls] end)):sum()
print(ans)

words = "one two three four five six seven eight nine"
