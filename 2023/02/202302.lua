-- use lpeg so you learn it -- not needed actually
local dump = (require "pl.pretty").dump
local lpeg = require "lpeg"
local C,P,R,Cc,Cf = lpeg.C, lpeg.P, lpeg.R, lpeg.Cc, lpeg.Cf

function pair(v, k) return {k, tonumber(v)} end
function merge(t1,t2)
  local t = t1[1] and {[t1[1]]=t1[2]} or t1
  if t2 then t[t2[1]] = t2[2] end
  return t
end
function tblize(...) return {...} end

local Number = R("09")^1
local Color = P("blue") + P("red") + P("green")
local Term = C(Number) * " " * C(Color) / pair
local Draw = Cf((Term * ", ")^0 * Term, merge)
local Draws = (Draw * "; ")^0 * Draw / tblize
local Game = P("Game ") * (C(Number) / tonumber) * ": " * Draws
n,t = Game:match("Game 11: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue")

function readData(fpath)
  local data = {}
  for line in io.lines(fpath) do
    g,draws = Game:match(line)
    data[g] = draws
  end
  return data
end

local tinput = readData("tinput.txt")

local max = math.max
function maxGame(draws)
  local r,g,b = 0,0,0
  for i,d in ipairs(draws) do
    r = max(r, d.red or 0)
    g = max(g, d.green or 0)
    b = max(b, d.blue or 0)
  end
  return r,g,b
end

function part1(data)
  local s = 0
  for gi,game in ipairs(data) do
    r,g,b = maxGame(game)
    if r <= 12 and g <= 13 and b <= 14 then
      s = s + gi
    end
  end
  return s
end

assert(part1(tinput) == 8)
local input = readData("input.txt")
print(part1(input))

function part2(data)
  local s = 0
  for gi,game in ipairs(data) do
    r,g,b = maxGame(game)
    assert(r ~= 0 and g ~= 0 and b ~= 0)
    s = s + r * g * b
  end
  return s
end

assert(part2(tinput) == 2286)
print(part2(input))





    
    