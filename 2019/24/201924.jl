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
    #println(gr)
    #println("START:")
    #println(string(gr))
    #println(hash(gr))

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

st = strip(read("input.txt", String))
gr = to_grid(st)
ans = part_one(gr)
println("PART 1: $ans")

