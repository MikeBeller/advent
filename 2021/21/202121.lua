local utils = require("pl.utils")
local List = require("pl.List")
local stringx = require "pl.stringx"
local pw = require("pl.pretty").write
local unpack = unpack or table.unpack
stringx.import()
utils.import('pl.func')
require "pl.strict"

local function parse(instr)
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

local format = string.format
local function ser(p1, p2, s1, s2)
    return format("%d,%d,%d,%d", p1, p2, s1, s2)
end

local byte = string.byte
local function deser(s)
    return unpack(s:split(","):map(tonumber))
end

-- Game state is {p1, p2, s1, s2} = pl 1 pos, pl 2 pos, pl 1 score, pl2 score
-- Score is 0 - 30 (since the max is to have score 20 + end up on square 10)
-- Pos is 1-10
local function part2(ps)
    local counts = {}
    local wp1, wp2 = 0, 0
    counts[ser(ps[1], ps[2], 0, 0)] = 1
    local trn = 1
    while true do
        local newcounts = {}
        for ss, c in pairs(counts) do
            local p1, p2, s1, s2 = deser(ss)
            local np1, np2, ns1, ns2, nss
            if trn % 2 == 1 then
                for roll, freq in pairs(ptable) do
                    np1 = (((p1 + roll) - 1) % 10) + 1
                    ns1 = s1 + np1
                    nss = ser(np1, p2, ns1, s2)
                    newcounts[nss] = (newcounts[nss] or 0) + freq * c
                    if ns1 >= 21 then
                        wp1 = wp1 + newcounts[nss]
                        newcounts[nss] = nil
                    end
                end
            else
                for roll, freq in pairs(ptable) do
                    np2 = (((p2 + roll) - 1) % 10) + 1
                    ns2 = s2 + np2
                    nss = ser(p1, np2, s1, ns2)
                    newcounts[nss] = (newcounts[nss] or 0) + freq * c
                    if ns2 >= 21 then
                        wp2 = wp2 + newcounts[nss]
                        newcounts[nss] = nil
                    end
                end
            end
        end
        if next(newcounts) == nil then
            break
        end
        counts = newcounts
        trn = trn + 1
    end
    --print(format("%.0f, %.0f", wp1, wp2))
    return math.max(wp1, wp2)
end

assert(part2(tinput) == 444356092776315)
print(format("PART2: %.0f", part2(input)))
