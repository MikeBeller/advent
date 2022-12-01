
function part1()
    local calories = {0}
    local ei = 1
    local mxi = 1
    for line in io.lines("input.txt") do
        if line == "" then
            calories[#calories+1] = 0
            ei = ei + 1
        else
            local n = tonumber(line)
            calories[ei] = calories[ei] + n
            if calories[ei] > calories[mxi] then
                mxi = ei
            end
        end
    end
    return calories[mxi]
end


print(part1())
