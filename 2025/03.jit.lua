require 'pl'
stringx.import()
local inp = List(io.lines("03.txt"))
  :map(s -> List(s):map(tonumber))

function jolt(a, n)
    local mxs = List({})
    local j = 1
    for i = n, 1, -1 do
        local mxi = List.range(j,#a-i+1):reduce(
            |mx,k| ->  (a[k] > a[mx]) ?  k : mx)
        mxs:append(a[mxi])
        j = mxi + 1
    end
    return mxs:reduce(|n,d| ->  10*n + d)
end

print(seq(inp):map(jolt, 2):sum())
print(string.format("%d", seq(inp):map(jolt, 12):sum()))
