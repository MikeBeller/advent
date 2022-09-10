
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

function gamma(data, nbits)
    local gamma = 0
    for bn = nbits-1, 0, -1 do
        local c = 0
        gamma = gamma << 1
        for i,v in ipairs(data) do
            if v & (1 << bn) ~= 0 then
                c = c + 1
            end
        end
        if c >= #data/2 then
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
