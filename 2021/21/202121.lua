require "pl.strict"
local utils = require("pl.utils")
local List = require("pl.List")
local stringx = require "pl.stringx"
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

local function play_game(tinput)
    local p1, p2 = unpack(tinput)
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
