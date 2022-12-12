package.path = "../lua/?.lua;" .. package.path
local ml = require('mikelib')
local List = ml.List

function chars(s)
    return List(string.gmatch(s, "."))
end

local priority = chars("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"):invert()
local tinput = List(io.lines("tinput.txt"))
local input = List(io.lines("input.txt"))

function common(lst1, lst2)
    local mp = lst1:invert()
    return lst2:filter(function (v) return mp[v] end)
end

function part1(data)
    local sm = 0
    for _, line in ipairs(data) do
        local ln2 = #line/2
        local s1,s2 = chars(string.sub(line, 1,ln2)), chars(string.sub(line, ln2+1, #line))
        local cm = common(s1, s2)
        sm = sm + priority[cm[1]]
    end
    return sm
end

assert(part1(tinput) == 157)
print(part1(input))

function part2(data)
    local sm = 0
    for i = 1, #data-2, 3 do
        local s1,s2,s3 = chars(data[i]), chars(data[i+1]), chars(data[i+2])
        local cm = common(common(s1, s2), s3)
        sm = sm + priority[cm[1]]
    end
    return sm
end

assert(part2(tinput) == 70)
print(part2(input))