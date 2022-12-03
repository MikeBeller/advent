require 'pl'
require 'pl.strict'
stringx.import()
local sub = string.sub

local alphas = List("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
local priority = tablex.index_map(alphas)

function part1(lines)
    local score = 0
    for _,line in ipairs(lines) do
        local ln2 = #line/2
        local a = Set(List(line):slice(1,ln2))
        local b = Set(List(line):slice(ln2+1,-1))
        print(a, b)
        local cm = a * b
        print(cm:values())
        score = score + priority[cm[1]]
    end
    return score
end

local tinput = io.input("tinput.txt"):read("*a"):splitlines()
local input = io.input("input.txt"):read("*a"):splitlines()

print(part1(tinput))