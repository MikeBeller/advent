

read_data(inp) = reduce(vcat, permutedims.(collect.(split(strip(inp), "\n"))))

tds = """
.#.
..#
###"""

widen(rs) = [(mn-1,mx+1) for (mn,mx) in rs]

active_neighbors(m, x, y, z) = count(get(m, (xx,yy,zz), false)
                                     for xx = (x-1):(x+1)
                                     for yy = (y-1):(y+1)
                                     for zz = (z-1):(z+1)
                                     if (xx,yy,zz) != (x,y,z))

function part1(data)
    m = Dict{Tuple{Int,Int,Int}, Bool}()
    dh,dw = size(data)
    z = 0
    for y = 1:dh
        for x = 1:dw
            m[(x,y,z)] = data[y,x] == '#'
        end
    end
    xr = (1,dw)
    yr = (1,dh)
    zr = (0,0)

    for i = 1:6
        (xr,yr,zr) = widen([xr, yr, zr])
        m2 = copy(m)
        for z = zr[1]:zr[2]
            for y = yr[1]:yr[2]
                for x = xr[1]:xr[2]
                    nact = active_neighbors(m, x, y, z)
                    if get(m, (x, y, z), false) # cube is active
                        if !(nact == 2 || nact == 3)
                            m2[(x,y,z)] = false
                        end
                    else # cube is inactive
                        if nact == 3
                            m2[(x,y,z)] = true
                        end
                    end
                end
            end
        end
        m = m2
    end

    count(values(m))
end

@assert part1(read_data(tds)) == 112
data = read_data(read("input.txt", String))
println("PART1: ", part1(data))

active_neighbors2(m, x, y, z, w) = count(get(m, (xx,yy,zz,ww), false)
                                     for xx = (x-1):(x+1)
                                     for yy = (y-1):(y+1)
                                     for zz = (z-1):(z+1)
                                     for ww = (w-1):(w+1)
                                     if (xx,yy,zz,ww) != (x,y,z,w))


function part2(data)
    m = Dict{Tuple{Int,Int,Int,Int}, Bool}()
    dh,dw = size(data)
    z = 0
    w = 0
    for y = 1:dh
        for x = 1:dw
            m[(x,y,z,w)] = data[y,x] == '#'
        end
    end
    xr = (1,dw)
    yr = (1,dh)
    zr = (0,0)
    wr = (0,0)

    for i = 1:6
        (xr,yr,zr,wr) = widen([xr, yr, zr, wr])
        m2 = copy(m)
        for w = wr[1]:wr[2]
            for z = zr[1]:zr[2]
                for y = yr[1]:yr[2]
                    for x = xr[1]:xr[2]
                        nact = active_neighbors2(m, x, y, z, w)
                        if get(m, (x, y, z, w), false) # cube is active
                            if !(nact == 2 || nact == 3)
                                m2[(x,y,z,w)] = false
                            end
                        else # cube is inactive
                            if nact == 3
                                m2[(x,y,z,w)] = true
                            end
                        end
                    end
                end
            end
        end
        m = m2
    end

    count(values(m))
end

@assert part2(read_data(tds)) == 848
data = read_data(read("input.txt", String))
println("PART2: ", part2(data))

