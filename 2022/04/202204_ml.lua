local M = require('ml').Array

function parse(line)
    return M.split(line, "[,%-]"):map(tonumber)
end

local tinput = M.collect(io.lines("tinput.txt")):map(parse)
local input = M.collect(io.lines("input.txt")):map(parse)

local function either_contains(pair)
    local a1,a2,b1,b2 = unpack(pair)
    return (a1 <= b1 and a2 >= b2) or (b1 <= a1 and b2 >= a2)
end

local function part1(pairs)
    return #(pairs:mapfilter(either_contains))
end

assert(part1(tinput) == 2)
print(part1(input))

local function overlaps(pair)
    local a1,a2,b1,b2 = unpack(pair)
    return (a1 <= b1 and a2 >= b1) or (b1 <= a1 and b2 >= a1)
end

local function part2(pairs)
    return #(pairs:mapfilter(overlaps))
end

assert(part2(tinput) == 4)
print(part2(input))
