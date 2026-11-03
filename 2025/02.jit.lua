require 'pl'
stringx.import() 
local inp = file.read("02.txt")
    :split(",")
    :map(p -> p:split("-"):map(tonumber))

function check(inp, pred)
    local c = 0
    for _,v in ipairs(inp) do
        for i = v[1],v[2] do
            if pred(tostring(i)) then c += i end
        end
    end
    return c
end

print(check(inp, s-> string.match(s,"^(.+)%1$")))
print(check(inp, s-> (s .. s):sub(2, -2):find(s, 1, true) ~= nil))
