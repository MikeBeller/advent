require 'pl'
stringx.import()

local function parse_line(line)
    -- return line:split('[,%-]'):map(tonumber)  -- bug in penlight (docs?)
    return List(utils.split(line, '[,%-]')):map(tonumber)
end

local function parse(instr)
    return instr:splitlines():map(parse_line)
end

local function either_contains(pair)
    local a1,a2,b1,b2 = unpack(pair)
    return (a1 <= b1 and a2 >= b2) or (b1 <= a1 and b2 >= a2)
end

local function part1(data)
    return data
        :map(either_contains)
        :count(true)
end

local tinput = parse(io.input("tinput.txt"):read("*a"))
local input = parse(io.input("input.txt"):read("*a"))

assert(part1(tinput) == 2)
print(part1(input))

local function overlaps(pair)
    local a1,a2,b1,b2 = unpack(pair)
    return (a1 <= b1 and a2 >= b1) or (b1 <= a1 and b2 >= a1)
end


local function part2(data)
    return data
        :map(overlaps)
        :count(true)
end


assert(part2(tinput) == 4)
print(part2(input))