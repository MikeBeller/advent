local stringx = require('pl.stringx')
stringx.import()
local List = require('pl.List')
local unpack = table.unpack
require "pl.strict"

local function parse_line(line)
    local pattern = "(%S+) x=(%-?%d+)%.%.(%-?%d+),y=(%-?%d+)%.%.(%-?%d+),z=(%-?%d+)%.%.(%-?%d+)"
    local caps = List({ line:match(pattern) })
    return caps:slice(1, 1) .. caps:slice(2, -1):map(tonumber)
end

local function parse(instr)
    return List(instr:lines()):map(parse_line)
end

local tinput = parse(io.input("tinput.txt"):read("*a"))

local min = math.min
local max = math.max

local function p1ind(x, y, z)
    return (((x + 50) * 101) + (y + 50)) * 101 + z
end

local function part1(inp)
    local m = List({})
    for item in inp:iter() do
        local cmd, xmin, xmax, ymin, ymax, zmin, zmax = unpack(item)
        local d = (cmd == "on") and 1 or nil
        for x = max(xmin, -50), min(xmax, 50) do
            for y = max(ymin, -50), min(ymax, 50) do
                for z = max(zmin, -50), min(zmax, 50) do
                    local ind = p1ind(x, y, z)
                    m[ind] = d
                end
            end
        end
    end
    local sm = 0
    for _, v in pairs(m) do
        sm = sm + v
    end
    return sm
end

assert(part1(tinput) == 590784)

local input = parse(io.input("input.txt"):read("*a"))
print("PART1:", part1(input))