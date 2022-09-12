
function read_data(path)
    local data = {}
    local nbits = nil
    for line in io.lines(path) do
        if nbits == nil then nbits = #line end
        data[#data + 1] = tonumber(line, 2)
    end
    return data, nbits
end

function bitn(n, bn)
    return (n >> bn) & 1 -- lua 5.4
    --return math.floor((n / (2 ^ bn) ) % 2)  -- luajit
end

function bitcounts(data, bn)
    local nzeros = 0
    local nones = 0
    for i,v in ipairs(data) do
        local b = bitn(v, bn)
        nones = nones + b
        nzeros = nzeros + (1 - b)
    end
    return nzeros, nones
end

function gamma(data, nbits)
    local gamma = 0
    for bn = nbits-1, 0, -1 do
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
    --local e = math.floor((-g - 1) % (2 ^ nbits)) -- luajit
    local e = ~g & ((1 << nbits) - 1)  -- lua 5.4
    return e * g
end

tdata,tnbits = read_data("tinput.txt")
assert(part1(tdata, tnbits) == 198)

data,nbits = read_data("input.txt")
print("PART1:", part1(data, nbits))

function criterion_o2(z, o)
    if o >= z then return 1 else return 0 end
end

function criterion_co2(z, o)
    if z <= o then return 0 else return 1 end
end

function rating(data, nbits, criterion)
    for bn = nbits-1, 0, -1 do
        local nzeros, nones = bitcounts(data, bn)
        local keep = criterion(nzeros, nones)
        local newdata = {}
        for i,v in ipairs(data) do
            if bitn(v, bn) == keep then
                table.insert(newdata, v)
            end
        end
        data = newdata
        if #data == 1 then break end
    end
    return data[1]
end

function part2(data, nbits)
    return rating(data, nbits, criterion_o2) * rating(data, nbits, criterion_co2)
end

assert(part2(tdata, tnbits) == 230)

print("PART2:", part2(data, nbits))

function bench(n)
    for i = 1, n do
        part2(data, nbits)
    end
end

bench(1000)