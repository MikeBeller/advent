function read_data(path)
    local data = {}
    local nbits = nil
    for line in io.lines(path) do
        if nbits == nil then nbits = #line end
        data[#data + 1] = tonumber(line, 2)
    end
    return data, nbits
end

function bitcounts(data, bn)
    local nzeros = 0
    local nones = 0
    for i,v in ipairs(data) do
        if v & (1 << bn) ~= 0 then
            nones = nones + 1
        else
            nzeros = nzeros + 1
        end
    end
    return nzeros, nones
end

function gamma(data, nbits)
    local gamma = 0
    for bn = nbits-1, 0, -1 do
        gamma = gamma << 1
        nzeros, nones = bitcounts(data, bn)
        if nzeros > nones then
            gamma = gamma + 1
        end
    end
    return gamma
end

function part1(data, nbits)
    g = gamma(data, nbits)
    e = g ~ ((1 << nbits) - 1)
    return e * g
end

tdata,tnbits = read_data("tinput.txt")
assert(part1(tdata, tnbits) == 198)

data,nbits = read_data("input.txt")
print("PART1:", part1(data, nbits))

function criterion_o2(z, o, bn)
    if o >= z then return 1 << bn else return 0 end
end

function criterion_co2(z, o, bn)
    if z <= o then return 0 else return 1 << bn end
end

function rating(data, nbits, criterion)
    for bn = nbits-1, 0, -1 do
        nzeros, nones = bitcounts(data, bn)
        local keep = criterion(nzeros, nones, bn)
        newdata = {}
        for i,v in ipairs(data) do
            if (1 << bn) & v == keep then
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