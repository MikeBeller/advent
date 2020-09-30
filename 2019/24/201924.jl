struct Grid
    nr::Int
    nc::Int
    s::BitSet
end

Grid() = Grid(5, 5, BitSet())

function Base.getindex(gr::Grid, r::Int, c::Int) ::Bool
    if r < 1 || r > gr.nr || c < 1 || c > gr.nc
        false
    else
        i = (r-1) * gr.nc + (c-1)
        i in gr.s
    end
end

function Base.setindex!(gr::Grid, v::Bool, r::Int, c::Int)
    @assert !(r < 1 || r > gr.nr || c < 1 || c > gr.nc)
    #@assert ! (v && (r,c) == (3,3))  # check for part two -- never set center cell
    i = (r-1) * gr.nc + (c-1)
    if v
        push!(gr.s, i)
    else
        pop!(gr.s, i, false)
    end
end

to_char(b::Bool) = b ? '#' : '.'

function Base.string(gr::Grid)
    rows = []
    for r in 1:gr.nr
        push!(rows, join(to_char(gr[r,c]) for c in 1:gr.nc))
    end
    join(rows, "\n")
end

function hash(gr::Grid)::Int
    sum(2^i for i in gr.s)
end

Base.length(gr::Grid) = length(gr.s)

function nadj(gr::Grid, r::Int, c::Int)
    n = 0
    n += gr[r-1,c] ? 1 : 0
    n += gr[r+1,c] ? 1 : 0
    n += gr[r,c-1] ? 1 : 0
    n += gr[r,c+1] ? 1 : 0
    n
end

function step(gr::Grid) ::Grid
    gr2 = Grid()
    for r in 1:gr.nr
        for c in 1:gr.nc
            v = gr[r, c]
            n = nadj(gr, r, c)
            if v && n != 1
                gr2[r, c] = false
            elseif !v && (n == 1 || n == 2)
                gr2[r, c] = true
            else
                gr2[r, c] = v
            end
        end
    end
    gr2
end

function to_grid(s)
    lines = split(s, "\n")
    gr = Grid()
    @assert length(lines) == gr.nr
    for r in 1:gr.nr
        for c in 1:gr.nc
            gr[r, c] = lines[r][c] == '#'
        end
    end
    gr
end

function part_one(gr)
    seen = Set([hash(gr)])
    while true
        gr = step(gr)
        h = hash(gr)
        if h in seen
            return h
        end
        push!(seen, h)
    end
    -1
end

function test1()
    st = """
    ....#
    #..#.
    #..##
    ..#..
    #...."""
    gr = to_grid(st)

    for i in 1:4
        gr = step(gr)
    end

    ans = """
    ####.
    ....#
    ##..#
    .....
    ##..."""
    @assert string(gr) == ans
end

function test2()
    ans = """
    .....
    .....
    .....
    #....
    .#..."""
    gr = to_grid(ans)
    @assert hash(gr) == 2129920
end

function test3()
    st = """
    ....#
    #..#.
    #..##
    ..#..
    #...."""
    gr = to_grid(st)
    ans = part_one(gr)
    @assert ans == 2129920
end

test1()
test2()
test3()

input_string = strip(read("input.txt", String))
starting_grid = to_grid(input_string)
ans1 = part_one(starting_grid)
println("PART 1: $ans1")

adj_map_raw = Dict(
           "A" => "B,F,-8,-12",
           "B" => "A,C,G,-8",
           "C" => "B,D,H,-8",
           "D" => "C,E,I,-8",
           "E" => "D,J,-8,-14",
           "F" => "A,G,K,-12",
           "G" => "B,F,H,L",
           "H" => "C,G,I,1,2,3,4,5",
           "I" => "D,H,J,N",
           "J" => "E,I,O,-14",
           "K" => "F,L,P,-12",
           "L" => "G,K,Q,1,6,11,16,21",
           "N" => "I,O,S,5,10,15,20,25",
           "O" => "J,N,T,-14",
           "P" => "K,Q,U,-12",
           "Q" => "L,P,R,V",
           "R" => "Q,S,W,21,22,23,24,25",
           "S" => "N,R,T,X",
           "T" => "O,S,Y,-14",
           "U" => "P,V,-18,-12",
           "V" => "Q,U,W,-18",
           "W" => "R,V,X,-18",
           "X" => "S,W,Y,-18",
           "Y" => "T,X,-14,-18",
          )

const AdjMap = Array{Vector{Tuple{Int,Int,Int}},2}

function to_coord(s::AbstractString) ::Tuple{Int,Int,Int}
    n = findfirst(s[1], "ABCDEFGHIJKLMNOPQRSTUVWXY")
    if !isnothing(n)
        n -= 1
        l = 0
        r = div(n,5)+1
        c = mod(n,5)+1
    else
        n = parse(Int, s)
        l = n < 0 ? -1 : 1
        n = abs(n)-1
        r = div(n, 5) + 1
        c = mod(n, 5) + 1
    end
    (l, r, c)
end
    
function digest_adj_map(raw::Dict{String,String}) ::AdjMap
    adj = AdjMap(undef, 5, 5)
    for (k,v) in raw
        l,r,c = to_coord(k)
        adj[r,c] = [to_coord(s) for s in split(v,",")]
    end
    adj
end

function nadj2(adj_map::AdjMap, grids::Dict{Int,Grid}, i::Int, r::Int, c::Int) ::Int
    gr = grids[i]
    grm1 = get(grids, i-1) do
        Grid()
    end
    grp1 = get(grids, i+1) do
        Grid()
    end
    grs = [grm1, gr, grp1]
    sum(grs[lev+2][r,c] for (lev,r,c) in adj_map[r,c])
end

function step2(adj_map::AdjMap, grids::Dict{Int,Grid}, i::Int)::Grid
    gr2 = Grid()
    gr = get!(grids, i) do
        Grid()
    end
    for r in 1:gr.nr
        for c in 1:gr.nc
            if (r,c) == (3,3); continue; end
            v = gr[r, c]
            n = nadj2(adj_map, grids, i, r, c)
            if v && n != 1
                gr2[r, c] = false
            elseif !v && (n == 1 || n == 2)
                gr2[r, c] = true
            else
                gr2[r, c] = v
            end
        end
    end
    gr2
end

function part_two(gr,nit)
    adj_map = digest_adj_map(adj_map_raw)
    grids = Dict{Int,Grid}(0 => gr)
    mni = 0
    mxi = 0
    for step in 1:nit
        # Advance all existing levels
        grids2 = Dict{Int,Grid}()
        for i in mni:mxi
            gr = grids[i]
            grids2[i] = step2(adj_map, grids, i)
        end

        # New higher up level
        gr2 = step2(adj_map, grids, mni-1)
        if length(gr2) > 0
            mni -= 1
            grids2[mni] = gr2
        end

        # New lower down level
        gr2 = step2(adj_map, grids, mxi+1)
        if length(gr2) > 0
            mxi += 1
            grids2[mxi] = gr2
        end

        grids = grids2
    end
    nbugs = sum(length(g) for g in values(grids))
    nbugs
end

function test21()
    st = """
    ....#
    #..#.
    #..##
    ..#..
    #...."""
    
    gr = to_grid(st)
    ans = part_two(gr, 10)
    @assert ans == 99
end

test21()

ans2 = part_two(starting_grid, 200)
println("PART 2: $ans2")

