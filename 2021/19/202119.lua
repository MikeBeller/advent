inspect = require("inspect")

function parse_group(gstr)
    local group = {}
    for x,y,z in gstr:gmatch("(-?%d+),(-?%d+),(-?%d+)") do
        group[#group+1] = {tonumber(x), tonumber(y), tonumber(z)}
    end
    return group
end

function parse_data(instr)
    local data = {}
    for group_str in instr:gmatch("(..-)\n\n") do
        data[#data+1] = parse_group(group_str)
    end
    return data
end


tinput = io.open("test_input.txt"):read("*a")
print(inspect(parse_data(tinput)))
