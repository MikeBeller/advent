local len = string.len
local band, rshift = bit.band, bit.rshift


function main()
    inp={}
    for n in io.open("input.txt"):lines("*n") do
        inp[#inp+1]=tonumber(n)
    end
    for i = 1,25 do
        new = {}
        for _,s in ipairs(inp) do
            if s == 0 then
                new[#new+1] = 1
            else
                ss = tostring(s)
                ln = len(ss)
                if band(ln,1) == 0 then
                --if ln & 1 == 0 then
                    ln2 = rshift(ln,1)
                    --ln2 = ln >> 1
                    new[#new+1] = tonumber(ss:sub(1,ln2))
                    new[#new+1] = tonumber(ss:sub(ln2+1))
                else
                    new[#new+1] = s * 2024
                end
            end
        end
        inp = new
    end
    print(#inp)
end

main()




