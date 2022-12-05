
-- read the lines from the file and parse them into a table
-- each line has format "a-b,c-d" where a,b,c,d are numbers, e.g. "1-2,3-4"
-- the first two numbers represent the start and end of the first range,
-- the second two numbers represent the start and end of the second range
-- the ranges are inclusive
function parse(filename)
    local file = io.open(filename, "r")
    local lines = {}
    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()
    local ranges = {}
    for _, line in ipairs(lines) do
        local range1, range2 = line:match("^(%d+-%d+),(%d+-%d+)$")
        local start1, stop1 = range1:match("^(%d+)-(%d+)$")
        local start2, stop2 = range2:match("^(%d+)-(%d+)$")
        table.insert(ranges, {tonumber(start1), tonumber(stop1), tonumber(start2), tonumber(stop2)})
    end
    return ranges
end

-- contained
-- check if either of the two ranges is entirely contained in the other
-- return 1 if true or 0 otherwise
function contained(ranges)
    local contained = 0
    for _, range in ipairs(ranges) do
        local start1, stop1, start2, stop2 = range[1], range[2], range[3], range[4]
        if start1 >= start2 and stop1 <= stop2 then
            contained = 1
            break
        elseif start2 >= start1 and stop2 <= stop1 then
            contained = 1
            break
        end
    end
    return contained
end

-- part1
-- for each command in the input table, check if the range represented
-- by the first two numbers is contained in the range represented by the
-- second two numbers, and vice versa
-- return the sum of the results
function part1(ranges)
    local sum = 0
    for _, range in ipairs(ranges) do
        sum = sum + contained({range})
    end
    return sum
end


-- check if the two ranges overlap
-- the ranges are inclusive
-- return 1 if they overlap and 0 otherwise
function overlap(range1, range2)
    local start1, stop1, start2, stop2 = range1[1], range1[2], range2[1], range2[2]
    if start1 <= stop2 and start2 <= stop1 then
        return 1
    else
        return 0
    end
end

-- part2
-- for each command in the input table, check if the range represented
-- by the first two numbers overlaps with the range represented by the
-- last two numbers, or vice versa
-- return the sum of the results
function part2(ranges)
    local sum = 0
    for _, range in ipairs(ranges) do
        sum = sum + overlap({range[1], range[2]}, {range[3], range[4]})
    end
    return sum
end

-- parse the lines in "tinput.txt" and store it in "tinput"
tinput = parse("tinput.txt")

-- parse the lines in "input.txt" and store it in "input"
input = parse("input.txt")

-- confirm that part1(tinput) returns 2
assert(part1(tinput) == 2)

-- print the result of part1(input)
print(part1(input))

-- confirm that part2(tinput) == 4
assert(part2(tinput) == 4)

-- print the result of part2(input)
print(part2(input))
