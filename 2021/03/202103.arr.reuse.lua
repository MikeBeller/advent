-- second approach using lua, uses a destructive process
-- to compute the rating (rather than creating a new table on each pass)
--
-- no appreciable difference in performance on lua 5.4, but 2x WORSE on luajit

function read_data(path)
    local data = {}
    local nbits = nil
    for line in io.lines(path) do
        if nbits == nil then nbits = #line end
        local d = {}
        for i = 1, nbits do
            local c = string.byte(line, i) - 48
            d[#d + 1] = c
        end
        data[#data + 1] = d
    end
    return data, nbits
end

function bitcounts(data, bn)
    local nzeros = 0
    local nones = 0
    for _,d in pairs(data) do
        local b = d[bn]
        nones = nones + b
        nzeros = nzeros + (1 - b)
    end
    return nzeros, nones
end

function bin_to_num(d, nbits)
    local r = 0
    for i = 1,nbits do
        r = r * 2 + d[i]
    end
    return r
end

function gamma(data, nbits)
    local gamma = 0
    for bn = 1,nbits do
        gamma = gamma * 2
        nzeros, nones = bitcounts(data, bn)
        if nones > nzeros then
            gamma = gamma + 1
        end
    end
    return gamma
end

function part1(data, nbits)
    local g = gamma(data, nbits)
    local e = math.floor((-g - 1) % (2 ^ nbits)) -- luajit
    --local e = ~g & ((1 << nbits) - 1)  -- lua 5.4
    return e * g
end

local tdata,tnbits = read_data("tinput.txt")
assert(part1(tdata, tnbits) == 198)

local data,nbits = read_data("input.txt")
print("PART1:", part1(data, nbits))

function criterion_o2(z, o)
    if o >= z then return 1 else return 0 end
end

function criterion_co2(z, o)
    if z <= o then return 0 else return 1 end
end

function rating(orig_data, nbits, criterion)
    local data = table.move(orig_data, 1, #orig_data, 1, {})
    local num = #data
    local lasti = nil
    for bn = 1,nbits do
        local nzeros, nones = bitcounts(data, bn)
        local keep = criterion(nzeros, nones)
        for i,v in pairs(data) do
            if v[bn] ~= keep then
                data[i] = nil
                num = num - 1
            else
                lasti = i
            end
        end
        if num == 1 then break end
    end
    return bin_to_num(data[lasti], nbits)
end

function part2(data, nbits)
    return rating(data, nbits, criterion_o2) * rating(data, nbits, criterion_co2)
end

assert(part2(tdata, tnbits) == 230)

print("PART2:", part2(data, nbits))

function bench(n, data, nbits)
    for i = 1, n do
        part2(data, nbits)
    end
end

bench(1000, data, nbits)
