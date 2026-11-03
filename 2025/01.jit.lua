require 'pl'
local inp = List(io.lines("01.txt"))
    :map(x -> tonumber(x:sub(2)) * (x:sub(1,1) == "R" ? 1 : -1))
local s,c = 50,0
for i = 1, #inp do s = (s + inp[i]) % 100; c += (s == 0 ? 1 : 0) end
print(c)

s,c = 50,0
for _,v in ipairs(inp) do
    local dr = (v < 0) ? -1 : 1
    for i = 1,(v*dr) do
        s += dr
        if s % 100 == 0 then
            c += 1
        end
        s = s % 100
    end
end
print(c)

