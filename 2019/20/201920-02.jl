
const Byte = UInt8

# Do everything 1-based for Julia
struct Point
    x::Int
    y::Int
end

function read_data(inp::String)::Tuple{Array{Byte,2}, Dict{String,Point}}
    rows = split(inp, "\n")
    if strip(rows[end]) == ""
        pop!(rows)
    end
    nr = length(rows)
    nc = length(rows[1])
    @assert all(length(r) == nc for r in rows)
    gr = zeros(Byte, nr-4, nc-4)
    port = Dict{String,Point}()

    for y in 1:nr
        for x in 1:nc
            c = rows[y][x]
            c2 = '\0'
            # if it's upper case we will visit the top or left character first
            # (since we scan l/r top to bottom
            if isuppercase(c)
                if y + 1 <= nr && isuppercase(rows[y+1][x])
                    c2 = rows[y+1][x]
                    # stacked top to bottom
                    if y+2 <= nr && rows[y+2][x] == '.'
                        # portal point is underneath
                        p = Point(x-2,y+2-2)
                    elseif y-1 >= 1 && rows[y-1][x] == '.'
                        # portal point is above
                        p = Point(x-2,y-2-1)
                    end
                elseif x+1 <= nc && isuppercase(rows[y][x+1])
                    c2 = rows[y][x+1]
                    # stacked left to right
                    if x+2 <= nc && rows[y][x+2] == '.'
                        # portal point is to right
                        p = Point(x+2-2,y-2)
                    elseif x-1 >= 1 && rows[y][x-1] == '.'
                        # portal point is to left
                        p = Point(x-2-1,y-2)
                    end
                end
            end
            if c2 != '\0'
                key = if x <=2 || y <=2 || x >= (nc-2) || y >= (nr-2)
                    string(c, c2)
                else
                    lowercase(string(c, c2))
                end
                port[key] = p
            end
            if y >= 3 && y <= nr - 2 && x >= 3 && x <= nc - 2
                c = rows[y][x]
                gr[y-2,x-2] = (c == '.') ? Byte('.') : Byte('#')
            end
        end
    end

    @assert haskey(port,"AA") && haskey(port,"ZZ")

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

function part_two(gr::Array{Byte,2}, port::Dict{String,Point})::Int
    pport = Dict( (p => s) for (s,p) in port)
    nr,nc = size(gr)
    vs = Dict{Tuple{Int,Point},Bool}()
    goal = port["ZZ"]
    start = port["AA"]
    q = [(1, start, 0)]

    total_dist = 0
    while length(q) != 0
        level,pos,dist = popfirst!(q)
        if !haskey(vs, (level,pos))
            vs[(level,pos)] = true
            if level == 1 && pos == goal
                total_dist = dist
                break
            end
            for dr = 0:3
                p,cc = move(gr, pos, dr)
                if cc == Byte('#')
                    continue
                end
                push!(q, (level, p, dist + 1))
            end
            key = get(pport, pos, "")
            if key != "" && key != "AA"
                if islowercase(key[1])
                    outkey = uppercase(key)
                    exit_point = port[outkey]
                    push!(q, (level+1, exit_point, dist+1))
                else
                    if level > 1 && key != "ZZ"
                        outkey = lowercase(key)
                        exit_point = port[outkey]
                        push!(q, (level-1, exit_point, dist+1))
                    end
                end
            end
        end
    end

    total_dist
end

function part_two_run(fname)
    instr = open(fname) do f
        read(f, String)
    end
    gr,port = read_data(instr)
    #print_gr(gr)
    #println(port)
    r = part_two(gr, port)
    r
end

function part_two_tests()
    @assert part_two_run("test1.txt") == 26
    @assert part_two_run("test3.txt") == 396
end

function main()
    r = part_two_run("input.txt")
    println("PART2: ", r)
end

part_two_tests()
main()

