local stringx = require('pl.stringx')
stringx.import()
local List = require('pl.List')
local Map = require('pl.Map')
local seq = require('pl.seq')
local unpack = table.unpack
local format = string.format
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

local function key(x, y, z)
    return format("%d,%d,%d", x, y, z)
end

local function index(ns)
    local ind = {}
    for i = 1, #ns do
        ind[ns[i]] = i
    end
    return Map(ind)
end

local function boot(inp)
    local xs, ys, zs = List(), List(), List()
    for item in inp:iter() do
        local cmd, xmin, xmax, ymin, ymax, zmin, zmax = unpack(item)
        xs:extend({ xmin, xmax })
        ys:extend({ ymin, ymax })
        zs:extend({ zmin, zmax })
    end
    xs:sort()
    ys:sort()
    zs:sort()
    local xind = index(xs)
    local yind = index(ys)
    local zind = index(zs)

    local m = Map()
    for item in inp:iter() do
        local cmd, xmin, xmax, ymin, ymax, zmin, zmax = unpack(item)
        local d = (cmd == "on") and 1 or 0
        for x = xind[xmin], (xind[xmax] - 1) do
            local x1 = (x + 1 == xind[xmax]) and 1 or 0
            for y = yind[ymin], (yind[ymax] - 1) do
                local y1 = (y + 1 == yind[ymax]) and 1 or 0
                for z = zind[zmin], (zind[zmax] - 1) do
                    local z1 = (z + 1 == zind[zmax]) and 1 or 0
                    m[key(x, y, z)] = d * (xs[x + 1] - xs[x] + x1) * (ys[y + 1] - ys[y] + y1) * (zs[z + 1] - zs[z] + z1)
                end
            end
        end
    end
    return seq(m:values()):sum()
end

local function part1b(inp)
    local inp2 = List()
    for item in inp:iter() do
        local cmd, xmin, xmax, ymin, ymax, zmin, zmax = unpack(item)
        inp2:append({ cmd, max(xmin, -50), min(xmax, 50),
            max(ymin, -50), min(ymax, 50),
            max(zmin, -50), min(zmax, 50) })
    end
    return boot(inp2)
end

print(part1b(tinput))
