
function ptable(t)
    for k,v in ipairs(t) do
        print(k, v)
    end
end

function read_data(path)
    local data = {}
    local len = nil
    for line in io.lines(path) do
        if len == nil then
            len = string.len(line)
        else
            assert(len == string.len(line))
        end
        data[#data + 1] = tonumber(line, 2)
    end
    return data, len
end

data,len = read_data("tinput.txt")
print(len)
ptable(data)
