

function parse_group(gstr)
    local group = {}
    for point in gstr:gmatch("([-]?%d+), ([-]?%d+), ([-]?%d+)") do
        print(table.unpack(point))
    end
    return group
end

function parse_data(instr)
    local data = {}
    for group_str in instr:gmatch("[,%w%- ]+") do
        data[#data+1] = parse_group(group_str)
        break
    end
    return data
end

tinput = io.open("test_input.txt"):read("*a")
print(parse_data(tinput))