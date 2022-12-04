require 'pl'
require 'pl.strict'
stringx.import()

local alphas = List("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
local priority = tablex.index_map(alphas)

function part1(lines)
    local score = 0
    for _,line in ipairs(lines) do
        local ln2 = #line/2
        local a = Set(List(line):slice(1,ln2))
        local b = Set(List(line):slice(ln2+1,-1))
        local cm = Set.values(Set.intersection(a, b))
        score = score + priority[cm[1]]
    end
    return score
end

local tinput = io.input("tinput.txt"):read("*a"):splitlines()
local input = io.input("input.txt"):read("*a"):splitlines()

assert(part1(tinput) == 157)
print("PART1:", part1(input))

function part2(lines)
    local score = 0
    for i = 1,#lines-2,3 do
        local a,b,c = Set(List(lines[i])), Set(List(lines[i+1])), Set(List(lines[i+2]))
        local cm = Set.values(Set.intersection(Set.intersection(a, b), c))
        score = score + priority[cm[1]]
    end
    return score
end

assert(part2(tinput) == 70)
print("PART2:", part2(input))
