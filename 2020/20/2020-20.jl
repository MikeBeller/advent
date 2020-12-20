

test1 = [
     '#' '.' '#';
     '#' '.' '.';
     '.' '#' '.']

fliptb(a) = reverse(a, dims=1)
fliplr(a) = reverse(a, dims=2)
rotate(a) = rotr90(a)

@assert fliptb(test1) == fliplr(rotate(rotate(test1)))
@assert rotl90(test1) == fliptb(fliplr(rotr90(test1)))

function gen_all(mx)
    r = []
    m = copy(mx)
    push!(r, m)
    push!(r, rotr90(m)) # only one rotation required for all orientations
    #for i = 2:4
    #    m = rotr90(m)  
    #    push!(r, m)
    #end

    for m in copy(r)
        push!(r, fliptb(m))
    end

    for m in copy(r)
        push!(r, fliplr(m))
    end

    #for m in r
    #    display(m)
    #    println()
    #end

    @assert length(unique(r)) == length(r)
    unique(r)
end

#gen_all(test1)
test2 = rand(Bool, (10,10))
gen_all(test2)

function tobin(v)
    if typeof(v[1]) == Char
        v = [x == '#' for x in v]
    end
    r = 0
    for (i,x) in enumerate(v)
        r *= 2
        r += x ? 1 : 0
    end
    r
end

function encode(m)
    # (t, b, l, r)
    (t=tobin(m[1,:]), b=tobin(m[end,:]), l=tobin(m[:,1]), r=tobin(m[:,end]))
end

@assert encode(test1) == (t=5, b=2, l=6, r=4)

function read_tile(ss)
    lines = split(strip(ss), "\n")
    f = split(lines[1], " ")
    tn = parse(Int, f[2][1:end-1])
    m = reduce(vcat, permutedims.(collect.(lines[2:end])))
    (tn, m)
end

function read_tiles(inp)
    tilestrs = split(strip(inp), "\n\n")
    [ read_tile(s) for s in tilestrs]
end

teststr = read("testinput.txt", String)
test_tiles = read_tiles(teststr)

function solve(ts, tn, n)
    m = zeros(Int, (n,n))
    tiles_left = Set(keys(ts))
    for y = 1:n
        for x = 1:n
            if y == 1 && x == 1
                m[1,1] = pop!(tiles_left, tn)
            elseif y == 1
                #try_all_matches_left
            elseif x == 1
                #try_all_matches_above
            else
                #try_all_matches_left_above
            end
        end
    end
end

function part1(tiles)
    n = sqrt(length(tiles))
    @assert n * n == length(tiles)
    all_tiles = Dict()
    for (tn,tm) in tiles
        all_tiles[tn] = [encode(m) for m in gen_all(tm)]
    end
    tns = collect(keys(tn))
    m = zeros(Int, (n,n))
    for tn in tns
        ok,m = solve(all_tiles, tn, n)
        if ok
            return m
        end
    end
    @assert false "no solution"
end

println(part1(test_tiles))

