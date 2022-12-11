package.path = "../lua/?.lua;" .. package.path
local M = require('ml')
local ts = M.tstring

function chars(s)
    return M.collect(string.gmatch(s, "."))
end

local priority = M.invert(chars("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"))
local tinput = M.collect(io.lines("tinput.txt"))
local input = M.collect(io.lines("input.txt"))

function common(s1, s2)
    local in_s1 = M.map2fun(M.invert(s1))
    return M.ifilter(s2, in_s1)
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