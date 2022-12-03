
function priority(c)
    if string.match(c,'%l') then
        return string.byte(c) - 96
    else
        return string.byte(c) - 64 + 26
    end
end

assert(priority('a') == 1 and priority('L') == 38)

function read_data(fpath)
    local data = {}
    for line in io.lines(fpath) do
        data[#data + 1] = line
    end
    return data
end

function common(groups)
    assert(#groups > 1)
    local count = {}
    local tgm = 0
    for gi = 1,#groups do
        local gr = groups[gi]
        local gm = 2 ^ gi
        tgm = tgm + gm
        for ci = 1, #gr do
            local x = string.sub(gr, ci, ci)
            count[x] = (count[x] or 0) + gm
            if gi == #groups and count[x] == tgm then
                print(require('pl.pretty').write(count), tgm, count[x], x)
                return x
            end
        end
    end
    error("no answer for pack " .. table.concat(groups, ","))
end

function part1(data)
    local score = 0
    for _,s in ipairs(data) do
        local ln2 = #s/2
        local cm = common({string.sub(s, 1,ln2), string.sub(s, ln2+1)})
        print(cm)
        score = score + priority(cm)
    end
    return score
end

local tinput = read_data("tinput.txt")
print(part1(tinput))
-- assert(part1(tinput) == 157)
-- local input = read_data("input.txt")
-- print("PART1:", part1(input))

-- function part2(data)
-- end