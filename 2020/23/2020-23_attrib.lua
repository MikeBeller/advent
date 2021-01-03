
function move(nxt)
    local cur = nxt.cur
    local ln = nxt.n
    local n1 = nxt[cur]
    local n2 = nxt[n1]
    local n3 = nxt[n2]
    nxt[cur] = nxt[n3]

    local dc = cur - 1
    if dc == 0 then dc = ln end
    while dc == n1 or dc == n2 or dc == n3 do
        dc = dc - 1
        if dc == 0 then dc = ln end
    end

    local nx = nxt[dc]
    nxt[dc] = n1
    nxt[n3] = nx
    cur = nxt[cur]

    nxt.cur = cur
end

function part2(init, nmoves)
    --local mx = 9
    local mx = 1000000
    local nxt = {}
    local p = init[1]
    local cur = p
    for i = 1,mx do
        if i ~= 9 then
            local nv = i
            if i < 9 then nv = init[i+1] end
            nxt[p] = nv
            --print("setting", p, "to", nv)
            p = nv
        end
    end
    nxt[p] = cur
    nxt.cur = cur
    nxt.n = mx

    local move = move
    for i = 1,nmoves do
        move(nxt)
    end

    local l1 = nxt[1]
    local l2 = nxt[l1]
    return l1 * l2
end

--print(part2({3, 8, 9, 1, 2, 5, 4, 6, 7}, 10000000))
print(part2({2, 1, 9, 7, 4, 8, 3, 6, 5}, 10000000))

