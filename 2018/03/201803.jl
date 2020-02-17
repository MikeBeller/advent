
function read_data(fpath)
    r = []
    for line in eachline(fpath)
        f = split(line, " ")
        ids = f[1]
        xs,ys = split(f[3], ",")
        ws,hs = split(f[4], "x")
        push!(r, (id=parse(Int32, ids[2:end]),
                  x=parse(Int32, xs), y=parse(Int32, ys[1:end-1]),
                  w=parse(Int32, ws), h=parse(Int32, hs)))
    end
    r
end

function extrema(data)
    (
     minimum(t -> t.x, data),
     minimum(t -> t.y, data),
     maximum(t -> t.x + t.w, data),
     maximum(t -> t.y + t.h, data),
    )
end

function part1(data)
    (mnx,mny,mxx,mxy) = extrema(data)
    @assert mnx == 0 && mny == 0
    field = zeros(Int32, (mxx+1,mxy+1))
    for t in data
        for x in t.x:(t.x+t.w-1)
            for y in t.y:(t.y+t.h-1)
                field[x+1, y+1] += 1
            end
        end
    end
    sum(field .> 1)
end

function part2(data)
    (mnx,mny,mxx,mxy) = extrema(data)
    field = zeros(Int32, (mxx+1,mxy+1))
    r = Set(d.id for d in data)
    for t in data
        for x in t.x:(t.x+t.w-1)
            for y in t.y:(t.y+t.h-1)
                if field[x+1, y+1] != 0
                    pop!(r, field[x+1,y+1], 0)
                    pop!(r, t.id, 0)
                    field[x+1, y+1] = -1
                else
                    field[x+1, y+1] = t.id
                end
            end
        end
    end
    r
end

function part2_blit(data)
    (mnx,mny,mxx,mxy) = extrema(data)
    field = zeros(Int32, (mxx+1,mxy+1))
    for t in data
        field[t.x+1:(t.x+t.w),t.y+1:(t.y+t.h)] .+= 1
    end
    for t in data
        if all(field[t.x+1:(t.x+t.w),t.y+1:(t.y+t.h)] .== 1)
            return t.id
        end
    end
end

function main()
    data = read_data("input.txt")
    ans1 = @time(part1(data))
    println("PART1: ", ans1)

    # second run only 40% faster than first
    ans2 = @time(part2(data))
    println("PART2: ", ans2)
    ans2 = @time(part2(data))
    println("PART2: ", ans2)

    # second run 36 times faster than first!!
    ans2b = @time(part2_blit(data))
    println("PART2b: ", ans2b)
    ans2b = @time(part2_blit(data))
    println("PART2b: ", ans2b)
end

main()

