
-- 'pure' lua version
-- function part1()
--     local calories = {0}
--     local ei = 1
--     local mxi = 1
--     for line in io.lines("input.txt") do
--         if line == "" then
--             calories[#calories+1] = 0
--             ei = ei + 1
--         else
--             local n = tonumber(line)
--             calories[ei] = calories[ei] + n
--             if calories[ei] > calories[mxi] then
--                 mxi = ei
--             end
--         end
--     end
--     return calories[mxi]
-- end

require 'pl.strict'
local seq = require 'pl.seq'
require('pl.stringx').import()

local input = io.input("input.txt"):read('*a')

local elves = input:split("\n\n"):map(function (group)
    return seq.sum(group:splitlines():map(tonumber))
end)

local _, ans1 = seq.minmax(elves)
print("PART1:", ans1)

elves:sort()
local ans2 = seq.sum(elves:slice(-3,-1))
print("PART2:", ans2)
