
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
            c = Byte(rows[y][x])
            gr[y,x] = c
            if c != '.' && c != '#'
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

    nc,nr = size(gr)
    c = if t.x < 1 || t.x > nc || t.y < 1 || t.y >= nr
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
        pos,dist = popleft!(q)
        if !vs[pos.y,pos.x]
            vs[pos.y,pos.x] = true
            c = gr[pos.y][pos.x]
            if is_key(c) && !(c in st.keys)
                dst[c] = dist
            end
            for dr = 0:3
                p,cc = move(gr, pos, dr)
                if cc == '#' || (is_door(cc) && !(keyForDoor(cc) in st.keys))
                    continue
                end
                push!(q, (p, dist + 1))
            end
        end
    end
    dst
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

test2 = """
########################
#f.D.E.e.C.b.A.@.a.B.c.#
######################.#
#d.....................#
########################"""

#println(read_data(test2))
gr,loc,n_keys = read_data(test2)

print_gr(gr)
println(loc)
println(n_keys)

