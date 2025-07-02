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

local function fill(inp)
  local r = expand(inp)
  local bcks = blocks(r)
  local fi = 1
  for bi = #bcks,2,-1 do
    local b = bcks[bi]
    if b.v ~= -1 then
      for bj = b.be,b.bs,-1 do
        while fi <= b.bs-1 do
          if r[fi] == -1 then
            r[fi] = r[bj]
            fi = fi + 1
            r[bj] = -1
            break
          else
            fi = fi + 1
          end
        end
      end
    end
  end
  -- dump(r)
  return r
end

local function checksum(r)
  local s = 0
  for i = 1, #r do
    if r[i] ~= -1 then
      s = s + r[i] * (i-1)
    end
  end
  return s
end

assert(checksum(fill(tinput)) == 1928)
print(checksum(fill(input)))


local function fill_blocks(inp)
  local r = expand(inp)
  local bcks = blocks(r)
  for bi = #bcks,2,-1 do
    local b = bcks[bi]
    if b.v ~= -1 then
      local sbcks = blocks(r)
      local si = 1
      while sbcks[si].be < b.bs do
        local sb = sbcks[si]
        if sb.v == -1 and sb.be - sb.bs >= b.be - b.bs then
          for i = 0,(b.be - b.bs) do
            r[sb.bs + i] = r[b.bs + i]
            r[b.bs + i] = -1
          end
        end
        si = si + 1
      end
    end
  end
  --dump(r)
  return r
end

assert(checksum(fill_blocks(tinput)) == 2858)
print(checksum(fill_blocks(input)))
