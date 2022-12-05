local sub = string.sub
local alpha = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
local T = {}
local S = {}

T.invert = function(tbl)
    local res = {}
    for k,v in pairs(tbl) do
        res[v] = k
    end
    return res
end

T.from_iter = function (itr)
    local res = {}
    for v in itr do
        res[#res+1] = v
    end
    return res
end

T.common = function (xs, ys)
    local pres = {}
    local res = {}
    for _,x in ipairs(xs) do
        pres[x] = true
    end
    for _,y in ipairs(ys) do
        if pres[y] then
            res[#res+1] = y
        end
    end
    return res
end

S.splitchars = function(str)
    return T.from_iter(string.gmatch(str, '.'))
end

local priority = T.invert(S.splitchars(alpha))

assert(priority['a'] == 1 and priority['L'] == 38)

function part1(data)
    local score = 0
    for _,s in ipairs(data) do
        local ln2 = #s/2
        local cm = T.common(S.splitchars(sub(s, 1,ln2)), S.splitchars(sub(s, ln2+1)))
        score = score + priority[cm[1]]
    end
    return score
end

local tinput = T.from_iter(io.lines("tinput.txt"))
assert(part1(tinput) == 157)
local input = T.from_iter(io.lines("input.txt"))
print("PART1:", part1(input))

function part2(data)
    local score = 0
    for di = 1, #data-2, 3 do
        local cm = T.common(
            T.common(S.splitchars(data[di]), S.splitchars(data[di+1])),
            S.splitchars(data[di+2]))
        score = score + priority[cm[1]]
    end
    return score
end

assert(part2(tinput) == 70)
print("PART2:", part2(input))