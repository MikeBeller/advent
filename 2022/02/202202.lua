local TX = require 'pl.tablex'
local SX = require 'pl.stringx'
require 'pl.strict'

local function parse(instr)
  return TX.map(SX.split, SX.splitlines(instr))
end

local input = parse(io.input("input.txt"):read("*a"))
local tinput = parse(io.input("tinput.txt"):read("*a"))

local R, P, S = 1,2,3
local shape_score = {1, 2, 3}
local win = {
  [R]={3, 6, 0},
  [P]={0, 3, 6},
  [S]={6, 0, 3},
}

local function score(them, us)
  return win[them][us] + shape_score[us]
end

local ttable = {A=R, B=P, C=S, X=R, Y=P, Z=S}
local ptable = {[R]='R', [P]='P', [S]='S'}

local function part1(input)
  local total_score = 0
  for i,round in ipairs(input) do
    local them_s, us_s = unpack(round)
    local them,us = ttable[them_s], ttable[us_s]
    local sc = score(them, us)
    total_score = total_score + sc
  end
  return total_score
end

assert(part1(tinput) == 15)
print("PART1:", part1(input))

local scheme = {
  X={S, R, P},
  Y={R, P, S},
  Z={P, S, R},
}

local function part2(input)
  local total_score = 0
  for i,round in ipairs(input) do
    local them_s, us_s = unpack(round)
    local them = ttable[them_s]
    local us = scheme[us_s][them]
    local sc = score(them, us)
    total_score = total_score + sc
  end
  return total_score
end

assert(part2(tinput) == 12)
print("PART2:", part2(input))
