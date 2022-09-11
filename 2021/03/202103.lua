
function ptable(t)
    for k,v in ipairs(t) do
        print(k, v)
    end
end

function read_data(path)
    local data = {}
    local nbits = nil
    for line in io.lines(path) do
        if nbits == nil then nbits = #line end
        data[#data + 1] = tonumber(line, 2)
    end
    return data, nbits
end

function mcb(data, bn)
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
        nzeros, nones = mcb(data, bn)
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

function rating(data, nbits, criterion)
    for bn = nbits-1, 0, -1 do
        nzeros, nones = mcb(data, bn)
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
    return data
end

function o2rating(data, nbits)
    return rating(data, nbits, function (z, o, bn)
        if z <= o then
            return 1 << bn
        else
            return 0
        end
    end)
end

print(o2rating(tdata, tnbits)[1])

