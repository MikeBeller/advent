function Mem()
    local tbl = {}
    local mt = {
        __index = function(t, addr)
            return rawget(tbl, addr + 1) or 0
        end,
        __newindex = function(t, addr, v)
            rawset(tbl, addr + 1, v)
        end
    }
    return setmetatable({}, mt)
end

foo = Mem()
print(foo[0], foo[1])
foo[0] = 77
print(foo[0], foo[1])
