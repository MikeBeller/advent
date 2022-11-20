require "pl.strict"
local utils = require("pl.utils")
local List = require("pl.List")
local stringx = require "pl.stringx"
local pw = require("pl.pretty").write
local unpack = unpack or table.unpack
stringx.import()
utils.import('pl.func')

function parse(instr)
    return (List(instr:lines())
        :map(_1:split(" ", 5)[5])
        :map(tonumber))
end

local tinput = parse(io.input("tinput.txt"):read("*a"))
assert(tinput == List({ 4, 8 }))

local function turn(p, d)
    p = p + 3 * d + 3
    p = (p - 1) % 10 + 1
    d = d + 3
    return p, d
end

local function play_game(input)
    local p1, p2 = unpack(input)
    local s1, s2 = 0, 0
    local d = 1
    while true do
        p1, d = turn(p1, d)
        s1 = s1 + p1
        if s1 >= 1000 then return s2 * (d - 1) end
        p2, d = turn(p2, d)
        s2 = s2 + p2
        if s2 >= 1000 then return s1 * (d - 1) end
    end
end

assert(play_game(tinput) == 739785)
local input = parse(io.input("input.txt"):read("*a"))
print("PART1:", play_game(input))

local ptable = (function()
    local t = {}
    for i = 1, 3 do
        for j = 1, 3 do
            for k = 1, 3 do
                local v = i + j + k
                t[v] = (t[v] or 0) + 1
            end
        end
    end
    return t
end)()

local function ser(st)
    return st:join(",")
end

local function deser(s)
    return s:split(","):map(tonumber)
end

local function part2(ps)
    local p1, p2 = unpack(ps)
    local s1, s2 = 0, 0
    local counts = {}
    local wp1, wp2 = 0, 0
    for trn = 1, 14 do
        for ss, c in pairs(counts) do
            p1, p2, s1, s2 = unpack(deser(ss))
            local np1, np2, ns1, ns2
            for roll, freq in pairs(ptable) do
                if trn % 2 == 1 then
                    np1 = (((p1 + roll) - 1) % 10) + 1
                    ns1 = s1 + np1
                    nss = ser({ np1, p2, ns1, s2 })
                    counts[nss] = (counts[nss] or 0) + freq
                    if counts[nss] >= 21 then
                        wp1 = wp1 + counts[nss]
                    end
                else
                    np2 = (((p2 + roll) - 1) % 10) + 1
                    ns2 = s2 + np2
                    nss = ser({ p1, np2, s1, ns2 })
                    counts[nss] = (counts[nss] or 0) + freq
                    if counts[nss] >= 21 then
                        wp2 = wp2 + counts[nss]
                    end
                end
            end
        end
    end
    return wp1, wp2
end

print(part2(tinput))
