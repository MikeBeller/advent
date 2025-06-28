local tinput = io.open("tinput.txt"):read("*a")
local input = io.open("input.txt"):read("*a")

local function expand(s)
  local r = {}
  for i = 1, #s do
    local c = s:sub(i,i)
    local n = tonumber(c)
    local x = -1
    if i % 2 == 1 then
      x = (i - 1)/2
    end
    for j = 1,n do
      r[#r+1] = x
    end
  end
  return r
end

local function blocks(xs)
  local r = {}
end

local function part1(inp)
  local r = expand(inp)
  print(r)
end

part1(tinput)
