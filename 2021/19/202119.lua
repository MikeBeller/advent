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

function parse(fpath)
    local data = {}
    local scanner = {}
    for line in io.lines(fpath) do
        if line:sub(1,3) == "---" then
            scanner = {}
            data[#data+1] = scanner
        elseif line == "" then
            -- pass
        else
            local xs,ys,zs = line:match("(-?%d+),(-?%d+),(-?%d+)")
            print( line:gmatch("(-?%d+),(-?%d+),(-?%d+)"))
            scanner[#scanner+1] = {tonumber(xs), tonumber(ys), tonumber(zs)}
        end
    end
    return data
end



print(inspect(parse("tinput.txt")))

