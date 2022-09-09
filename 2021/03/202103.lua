
function ptable(t)
    for k,v in ipairs(t) do
        print(k, v)
    end
end

function read_data(path)
    local data = {}
    for line in io.lines(path) do
        data[#data + 1] = tonumber(line, 2)
    end
    return data
end

data = read_data("tinput.txt")
ptable(data)
