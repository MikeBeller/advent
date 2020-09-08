
const Byte = UInt8

# Do everything 1-based for Julia
struct Point
    x::Int
    y::Int
end

function read_data(inp::String)::Tuple{Array{Byte,2}, Dict{String,Vector{Point}}}
    rows = split(inp, "\n")
    if strip(rows[end]) == ""
        pop!(rows)
    end
    nr = length(rows)
    nc = length(rows[1])
    @assert all(length(r) == nc for r in rows)
    gr = zeros(Byte, nr-4, nc-4)
    port = Dict{String,Vector{Point}}()

    for y in 1:nr
        for x in 1:nc
            p = Point(0,0)
            c = rows[y][x]
            # if it's upper case we will visit the top or left character first
            # (since we scan l/r top to bottom
            if isuppercase(c)
                println(x, " ", y)
                if y + 1 <= nr && isuppercase(rows[y+1][x])
                    c2 = rows[y+1][x]
                    # stacked top to bottom
                    if y+2 <= nr && rows[y+2][x] == '.'
                        # portal point is underneath
                        p = Point(x,y+2)
                    elseif y-1 >= 1 && rows[y-1][x] == '.'
                        # portal point is above
                        p = Point(x,y-1)
                    else
                        continue
                    end
                elseif x+1 <= nc && isuppercase(rows[y][x+1])
                    c2 = rows[y][x+1]
                    # stacked left to right
                    if x+2 <= nr && rows[y][x+2] == '.'
                        # portal point is to right
                        p = Point(x+2,y)
                    elseif x-1 >= 1 && rows[y][x-1] == '.'
                        # portal point is to left
                        p = Point(x-1,y)
                    else
                        error("wtf2? ", x, " ", y)
                    end
                else
                    continue
                end
                key = string(c, c2)
                v = get!(port, key, [])
                push!(v, p)
            else
                if y >= 3 && y <= nr - 2 && x >= 3 && x <= nc - 2
                    c = rows[y][x]
                    gr[y-2,x-2] = if c == ' ' || c == '#'
                        Byte('#')
                    elseif c == '.'
                        Byte('.')
                    else
                        error("???")
                    end
                end
            end
        end
    end

    gr, port
end

function move(gr::Array{Byte,2}, f::Point, dr::Int)::Tuple{Point,Byte}
    t = if dr == 0
        Point(f.x, f.y - 1)
    elseif dr == 1
        Point(f.x + 1, f.y)
    elseif dr == 2
        Point(f.x, f.y + 1)
    elseif dr == 3
        Point(f.x - 1, f.y)
    else
        @assert false "Invalid direction"
    end

    nr,nc = size(gr)
    c = if t.x < 1 || t.x > nc || t.y < 1 || t.y > nr
        Byte('#')
    else
        gr[t.y,t.x]
    end

    t,c
end

function print_gr(gr)
    nr,nc = size(gr)
    for r = 1:nr
        for c = 1:nc
            print(Char(gr[r,c]))
        end
        println()
    end
end

function part_one_test(fname)
    instr = open(fname) do f
        read(f, String)
    end
    gr,port = read_data(instr)
    print_gr(gr)
    println(port)
end

function part_one_tests()
    part_one_test("test1.txt")
end

part_one_tests()

