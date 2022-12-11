package.path = "../lua/?.lua;" .. package.path
local ml = require('ml')
local split, List = ml.split, ml.List
local unpack = table.unpack or unpack

function parse(line)
    return split(line, "[,%-]"):map(tonumber)
end

local tinput = List(io.lines("tinput.txt")):map(parse)
local input = List(io.lines("input.txt")):map(parse)

local function either_contains(ranges)
    local a1,a2,b1,b2 = unpack(ranges)
    return (a1 <= b1 and a2 >= b2) or (b1 <= a1 and b2 >= a2)
end

local function part1(ranges)
    return ranges:count(either_contains)
end

assert(part1(tinput) == 2)
print(part1(input))

local function overlaps(ranges)
    local a1,a2,b1,b2 = unpack(ranges)
    return (a1 <= b1 and a2 >= b1) or (b1 <= a1 and b2 >= a1)
end

local function part2(ranges)
    return ranges:count(overlaps)
end

assert(part2(tinput) == 4)
print(part2(input))
