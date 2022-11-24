local stringx = require('pl.stringx')
stringx.import()
local List = require('pl.List')
local Map = require('pl.Map')
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

local input = parse(io.input("input.txt"):read("*a"))

local function index(ns)
    local ind = {}
    for i = 1, #ns do
        ind[ns[i]] = i
    end
    return Map(ind)
end

local function boot(inp_raw)
    local xs, ys, zs = List(), List(), List()
    local inp = List()
    for item in inp_raw:iter() do
        local cmd, xmin, xmax, ymin, ymax, zmin, zmax = unpack(item)
        xs:extend({ xmin, xmax + 1 })
        ys:extend({ ymin, ymax + 1 })
        zs:extend({ zmin, zmax + 1 })
        inp:append({ cmd, xmin, xmax + 1, ymin, ymax + 1, zmin, zmax + 1 })
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
            local mx = m[x] or {}
            m[x] = mx
            for y = yind[ymin], (yind[ymax] - 1) do
                local mxy = mx[y] or {}
                m[x][y] = mxy
                for z = zind[zmin], (zind[zmax] - 1) do
                    mxy[z] = d * (xs[x + 1] - xs[x]) * (ys[y + 1] - ys[y]) * (zs[z + 1] - zs[z])
                end
            end
        end
    end
    local sm = 0
    for _, mx in pairs(m) do
        for _, mxy in pairs(mx) do
            for _, zv in pairs(mxy) do
                sm = sm + zv
            end
        end
    end
    return sm
end

local function part1(inp)
    local inp2 = List()
    for item in inp:iter() do
        local cmd, xmin, xmax, ymin, ymax, zmin, zmax = unpack(item)
        inp2:append({ cmd, max(xmin, -50), min(xmax, 50),
            max(ymin, -50), min(ymax, 50),
            max(zmin, -50), min(zmax, 50) })
    end
    return boot(inp2)
end

assert(part1(tinput) == 590784)
print("PART1:", part1(input))

local tinput2 = parse(io.input("tinput2.txt"):read("*a"))

local function part2(inp)
    return boot(inp)
end

assert(part2(tinput2) == 2758514936282235)
print(format("PART2: %.0f", part2(input)))
