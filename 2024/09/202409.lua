local insert = table.insert

local function dump(tbl, indent, visited)
  indent = indent or ""; visited = visited or {}
  if visited[tbl] then print(indent .. "*RECURSION*"); return end
  visited[tbl] = true
  for k, v in pairs(tbl) do
    local key = tostring(k)
    if type(v) == "table" then
      print(indent .. key .. " = {")
      dump(v, indent .. "  ", visited)
      print(indent .. "}")
    else
      print(indent .. key .. " = " .. tostring(v))
    end
  end
end

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
  local v = xs[1]
  local bs = 1
  for i = 1,#xs do
    if xs[i] ~= v then
      r[#r + 1] = {bs=bs, be=i-1, v=v}
      bs = i
      v = xs[i]
    end
  end
  if bs ~= #xs then
    r[#r + 1] = {bs=bs, be=#xs, v=v}
  end
  --dump(r)
  return r
end

local function part1(inp)
  local r = expand(inp)
  local bs = blocks(r)
  
  --dump(r)
end

part1(tinput)
