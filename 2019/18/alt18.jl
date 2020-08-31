
const Byte = UInt8

struct Point
    x::Int
    y::Int
end

function is_key(c::Byte)::Bool
    c >= Byte('a') && c <= Byte('z')
end

function is_door(c::Byte)::Bool
    c >= Byte('A') && c <= Byte('Z')
end

function key_for_door(c::Byte)::Byte
    @assert is_door(c)
    c + 32
end

function key_locations(gr::Array{Byte,2}) ::Dict{Byte,Point}
    nr,nc = size(gr)
    loc = Dict{Byte,Point}()
    for y = 1:nr
        for x = 1:nc
            c = gr[y, x]
            if c != Byte('.') && c != Byte('#')
                loc[c] = Point(x, y)
            end
        end
    end
    loc
end

function read_data(inp::String)::Tuple{Array{Byte,2}, Dict{Byte,Point}}
    rows = split(inp, "\n")
    nr = length(rows)
    nc = length(rows[1])
    gr = zeros(Byte, nr, nc)
    loc = Dict{Byte, Point}()

    for y = 1:nr
        if length(rows[y]) != nc
            break
        end
        for x = 1:nc
            c::Byte = Byte(rows[y][x])
            gr[y,x] = c
        end
    end
    loc = key_locations(gr)

    gr, loc
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

function key_for_door(c::Byte)::Byte
    @assert is_door(c)
    c + 32
end

function key_distances(gr::Array{Byte,2}, from_pos::Point, keys::BitSet)::Dict{Byte,Int}
    dst = Dict{Byte,Int}()
    vs = falses(size(gr)...)
    q = [(from_pos, 0)]

    while length(q) != 0
        pos,dist = popfirst!(q)
        if !vs[pos.y,pos.x]
            vs[pos.y,pos.x] = true
            c = gr[pos.y,pos.x]
            if is_key(c) && !(c in keys)
                dst[c] = dist
            end
            for dr = 0:3
                p,cc = move(gr, pos, dr)
                if cc == Byte('#') || (is_door(cc) && !(key_for_door(cc) in keys))
                    continue
                end
                push!(q, (p, dist + 1))
            end
        end
    end
    dst
end

function num_keys(loc::Dict{Byte,Point}) ::Int
    sum(is_key(c) for c in keys(loc))
end

function part_one(instr::String)::Int
    gr, loc = read_data(instr)
    n_keys = num_keys(loc)
    dists = Dict{Tuple{Point,BitSet}, Int}( [((loc[Byte('@')], BitSet()), 0)])
    for depth = 1:n_keys
        println("GEN ", depth, " SIZE ", length(dists))

        dist_list = collect(dists)
        dists = Dict{Tuple{Point,BitSet}, Int}()
        for ((pos,keys),total_dist) in dist_list
            kds = key_distances(gr, pos, keys)
            for (k,dist) in kds
                new_pos = loc[k]
                new_keys = union(keys, [k])
                new_total_dist = total_dist + dist
                t = (new_pos, new_keys)
                if !haskey(dists, t) || new_total_dist < dists[t]
                    dists[t] = new_total_dist
                end
            end
        end
    end

    minimum(values(dists))
end

function partition_graph(gr1::Array{Byte,2}, loc1::Dict{Byte,Point}) ::Tuple{Vector{Array{Byte,2}},Vector{Dict{Byte,Point}}}
    p = loc1[Byte('@')]
    nr,nc = size(gr1)
    gr1[p.y-1:p.y+1,p.x-1:p.x+1] = [b"@#@"; b"###"; b"@#@"]
    gr = [
          gr1[1:p.y,1:p.x],
          gr1[1:p.y,p.x:nc],
          gr1[p.y:nr,1:p.x],
          gr1[p.y:nr,p.x:nc],
         ]
    loc = [key_locations(g) for g in gr]
    gr, loc
end

# Like part_one but partitioned into 4 quadrants, so
# gr, loc, n_keys become Vectors of length 4
function part_two(instr::String)::Int
    gr1, loc1 = read_data(instr)
    n_keys = num_keys(loc1)
    grs, locs = partition_graph(gr1, loc1)
    for (i,g) in enumerate(grs)
        println(i,":")
        print_gr(g)
    end
    0
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

function part_one_tests()
    test2 = """
    ########################
    #f.D.E.e.C.b.A.@.a.B.c.#
    ######################.#
    #d.....................#
    ########################"""

    t2ans = part_one(test2)
    @assert t2ans == 86

    test3 = """
    ########################
    #...............b.C.D.f#
    #.######################
    #.....@.a.B.c.d.A.e.F.g#
    ########################"""

    t3ans = part_one(test3)
    println(t3ans)

    test4 = """
    #################
    #i.G..c...e..H.p#
    ########.########
    #j.A..b...f..D.o#
    ########@########
    #k.E..a...g..B.n#
    ########.########
    #l.F..d...h..C.m#
    #################"""

    t4ans = part_one(test4)
    println(t4ans)
    @assert t4ans == 136
end

function part_two_tests()
    test21 = """
    #######
    #a.#Cd#
    ##...##
    ##.@.##
    ##...##
    #cB#Ab#
    #######"""

    ans = part_two(test21)
    @assert ans == 0

end

function main()
    instr = open("input.txt") do f
        read(f, String)
    end
    ans = part_one(instr)
    println("PART ONE ", ans)
end

#part_one_tests()
#part_two_tests()
@time main()

