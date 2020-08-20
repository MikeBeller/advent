
const Byte = UInt8

struct Point
    x::Int
    y::Int
end

struct State
    pos::Point
    total_dist::Int
    keys::BitSet
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

function read_data(inp::String)::Tuple{Array{Byte,2}, Dict{Byte,Point}, Int}
    rows = split(inp, "\n")
    nr = length(rows)
    nc = length(rows[1])
    gr = zeros(Byte, nr, nc)
    loc = Dict{Byte, Point}()
    n_keys = 0

    for y = 1:nr
        if length(rows[y]) != nc
            break
        end
        for x = 1:nc
            c::Byte = Byte(rows[y][x])
            gr[y,x] = c
            if c != Byte('.') && c != Byte('#')
                loc[c] = Point(x, y)
                if is_key(c)
                    n_keys += 1
                end
            end
        end
    end

    gr, loc, n_keys
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

function key_distances(gr::Array{Byte,2}, st::State)::Dict{Byte,Int}
    dst = Dict{Byte,Int}()
    vs = falses(size(gr)...)
    q = [(st.pos, 0)]

    while length(q) != 0
        pos,dist = popfirst!(q)
        if !vs[pos.y,pos.x]
            vs[pos.y,pos.x] = true
            c = gr[pos.y,pos.x]
            if is_key(c) && !(c in st.keys)
                dst[c] = dist
            end
            for dr = 0:3
                p,cc = move(gr, pos, dr)
                if cc == Byte('#') || (is_door(cc) && !(key_for_door(cc) in st.keys))
                    continue
                end
                push!(q, (p, dist + 1))
            end
        end
    end
    dst
end

function get_key(k::Byte, p::Point, dist::Int, s::State)::State
    State(p, s.total_dist + dist, union(s.keys,[k]))
end

function best_states_by_pos_and_keys(q::Vector{State})::Vector{State}
    uq = Dict{Tuple{Point,BitSet},State}()
    for s in q
        t = (s.pos, s.keys)
        if !haskey(uq, t) || s.total_dist < uq[t].total_dist
            uq[t] = s
        end
    end
    collect(values(uq))
end

function part_one(instr::String)::Int
    gr, loc, n_keys = read_data(instr)
    q = Vector{State}([State(loc[Byte('@')], 0, BitSet())])
    for depth = 1:n_keys
        println("GEN ", depth, " SIZE ", length(q))
        best_states = best_states_by_pos_and_keys(q)

        q = Vector{State}()
        for s in best_states
            kds = key_distances(gr, s)
            for (k,dist) in kds
                push!(q, get_key(k, loc[k], dist, s))
            end
        end
    end

    min_dist = minimum(q) do s
        s.total_dist
    end
    min_dist
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

function tests()
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

function main()
    instr = open("input.txt") do f
        read(f, String)
    end
    ans = part_one(instr)
    println("PART ONE ", ans)
end

tests()
@time main()


