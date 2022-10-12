local function loop(n)
    local s = 0
    for i = 0, n - 1 do
        s = s + i
    end
    return s
end

print(loop(100000000))
