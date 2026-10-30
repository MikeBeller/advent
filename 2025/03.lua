require 'pl'
stringx.import()
local inp = List(io.lines("03.txt"))
  :map(function(s) return List(s):map(tonumber) end)

function jolt(a, n)
    local mxs = List({})
    local j = 1
    for i = n, 1, -1 do
        local mxi = List.range(j,#a-i+1):reduce(
            function (mx,k) return a[k] > a[mx] and k or mx end)
        mxs:append(a[mxi])
        j = mxi + 1
    end
    return mxs:reduce(function (n,d) return 10*n + d end)
end

local p1 = seq(inp):map(jolt, 2):sum()
print(p1)
local p2 = seq(inp):map(jolt, 12):sum()
print(p2)
