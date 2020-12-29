
function move(cur, nxt)
    ln = length(nxt)

    n1 = nxt[cur]
    n2 = nxt[n1]
    n3 = nxt[n2]
    nxt[cur] = nxt[n3]

    dc = cur - 1
    if dc == 0 dc = ln end
    while dc == n1 || dc == n2 || dc == n3
        dc -= 1
        if dc == 0 dc = ln end
    end

    nx = nxt[dc]
    nxt[dc] = n1
    nxt[n3] = nx

    cur = nxt[cur]
    cur
end

function part1(cs, nmoves)
    ln = length(cs)
    nxt = zeros(Int32, ln)
    p = cs[1]
    for i = 1:(ln-1)
        nxt[p] = cs[i+1]
        p = nxt[p]
    end
    nxt[p] = cs[1]
    cur = cs[1]
    for i = 1:nmoves
        cur = move(cur, nxt)
    end
    r = []
    p = 1
    while nxt[p] != 1
        push!(r, nxt[p])
        p = nxt[p]
    end
    r
end

@assert part1([3, 8, 9, 1, 2, 5, 4, 6, 7], 10) == [9, 2, 6, 5, 8, 3, 7, 4]

function part2(cs, nmoves)
    nxt = zeros(Int32, 1000000)
    #nxt = Dict{Int32,Int32}()
    p = cs[1]
    for i = 2:1000000
        if i <= 9
            nxt[p] = cs[i]
        else
            nxt[p] = i
        end
        p = nxt[p]
    end
    nxt[p] = cs[1]

    cur = cs[1]
    for i = 1:nmoves
        cur = move(cur, nxt)
    end

    l1 = nxt[1]
    l2 = nxt[l1]

    return Int64(l1) * Int64(l2)
end

@assert part2([3, 8, 9, 1, 2, 5, 4, 6, 7], 10000000) == 149245887792
a = @time part2([2, 1, 9, 7, 4, 8, 3, 6, 5], 10000000)
println("PART2: ", a)



