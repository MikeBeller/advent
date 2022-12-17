
local function search(s, n)
    local buf = {}
    local count = {}
    local nc = 0
    for i = 1, #s do
        local oc = buf[i % n + 1]
        if oc then
            count[oc] = count[oc] - 1
            if count[oc] == 0 then
                nc = nc - 1
            end
        end
        local c = s:sub(i, i)
        buf[i % n + 1] = c
        count[c] = (count[c] or 0) + 1
        if count[c] == 1 then
            nc = nc + 1
            if nc == n then
                return i
            end
        end
    end
end

-- part1 call search with input string and n = 4
local function part1(s)
    return search(s, 4)
end

assert(part1("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 7)
assert(part1("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5)
assert(part1("nppdvjthqldpwncqszvftbrmjlhg") == 6)
assert(part1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10)
assert(part1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11)

local input = io.input("input.txt"):read("*a")

print("Part 1:", part1(input))

-- part2 call search with input string and n = 14
local function part2(s)
    return search(s, 14)
end

assert(part2("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 19)
assert(part2("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23)
assert(part2("nppdvjthqldpwncqszvftbrmjlhg") == 23)
assert(part2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 29)
assert(part2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 26)

print("Part 2:", part2(input))

