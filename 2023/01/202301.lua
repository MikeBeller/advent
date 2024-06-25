require 'pl'
stringx.import()
function digs(s) return List(s:gmatch("%d")) end
input = file.read("input.txt"):splitlines()
ans = seq(input:map(digs)
  :map(function (ls) return ls[1]*10 + ls[#ls] end)):sum()
print(ans)

words = ("one two three four five six seven eight nine"):split(" ")
function num(s, i)
  x = s:match("^(%d)",i)
  if x then return x end
  for n,w in ipairs(words) do
    if s:match("^" .. w,i) then return n end
  end
  return nil
end

input = file.read("input.txt"):splitlines()
function nums(line)
  nms = List()
  for i = 1,line:len() do
    nm = num(line, i)
    if nm then nms:append(nm) end
  end
  return nms[1] * 10 + nms[#nms]
end
ans = seq(input):map(nums):sum()
print(ans)