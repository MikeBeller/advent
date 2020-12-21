

test1 = [
     '#' '.' '#';
     '#' '.' '.';
     '.' '#' '.']

fliptb(a) = reverse(a, dims=1)
fliplr(a) = reverse(a, dims=2)
rotate(a) = rotr90(a)

@assert fliptb(test1) == fliplr(rotate(rotate(test1)))
@assert rotl90(test1) == fliptb(fliplr(rotr90(test1)))

function gen_all_rot_flip(mx)
    r = []
    m = copy(mx)
    push!(r, m)
    push!(r, rotr90(m)) # only one rotation required for all orientations
                        # (when combined with the flips that is)

    for m in copy(r)
        push!(r, fliptb(m))
    end

    for m in copy(r)
        push!(r, fliplr(m))
    end

    @assert length(unique(r)) == length(r)
    r
end

test2 = rand(Bool, (10,10))
gen_all_rot_flip(test2)

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

const Code = NamedTuple{(:t, :b, :l, :r), Tuple{Int,Int,Int,Int}}

tiles_with_left_equal(tiles, unused, val) = [(i,j) for i in unused
                                             for j in 1:8
                                             if tiles[i][j].l == val]
tiles_with_top_equal(tiles, unused, val) = [(i,j) for i in unused
                                             for j in 1:8
                                             if tiles[i][j].t == val]
tiles_with_top_left_equal(tiles, unused, tval, lval) = [(i,j) for i in unused
                                                for j in 1:8
                                            if tiles[i][j].t == tval && tiles[i][j].l == lval]

function solve(tiles::Dict{Int,Vector{Code}}, n::Int, w::Int, mat::Array{Int,3}, r::Int, c::Int, ti::Tuple{Int,Int}, unused::BitSet)::Tuple{Bool,Array{Int,3}}
    m = copy(mat)
    (tii,tir) = ti
    m[r, c, 1] = tii
    m[r, c, 2] = tir
    pop!(unused, tii)
    if (r,c) == (w,w)
        return (true, m)
    end

    c += 1
    if c > w
        c = 1
        r += 1
    end
    if r == 1
        @assert !(r == 1 && c == 1)
        rr,cc = r,c-1
        rightval = tiles[m[rr,cc,1]][m[rr,cc,2]].r

        for tile in tiles_with_left_equal(tiles, unused, rightval)
            (ok,m2) = solve(tiles, n, w, m, r, c, tile, unused)
            if ok
                return (ok, m2)
            end
        end
    elseif c == 1
        rr,cc = r-1,c
        bottomval = tiles[m[rr,cc,1]][m[rr,cc,2]].b
        for tile in tiles_with_top_equal(tiles, unused, bottomval)
            (ok,m2) = solve(tiles, n, w, m, r, c, tile, unused)
            if ok
                return (ok, m2)
            end
        end
    else
        rr,cc = r,c-1
        rightval = tiles[m[rr,cc,1]][m[rr,cc,2]].r
        rr,cc = r-1,c
        bottomval = tiles[m[rr,cc,1]][m[rr,cc,2]].b
        for tile in tiles_with_top_left_equal(tiles, unused, bottomval, rightval)
            (ok,m2) = solve(tiles, n, w, m, r, c, tile, unused)
            if ok
                return (ok, m2)
            end
        end
    end
    (false, m)
end

function part1(tiles)
    n = length(tiles)
    w = isqrt(n)
    @assert w * w == n
    all_tiles = Dict{Int,Vector{Code}}()
    tn_to_i = Dict{Int,Int}()
    i_to_tn = Dict{Int,Int}()
    for (i,(tn,tm)) in enumerate(tiles)
        all_tiles[i] = [encode(m) for m in gen_all_rot_flip(tm)]
        tn_to_i[tn] = i
        i_to_tn[i] = tn
    end

    for i = 1:n
        for j = 1:8
            m = zeros(Int,(w,w,2))  # use will be m[r,c,1] = tile index, m[r,c,2] = tile rotation
            unused = BitSet(1:n)
            ok,m = solve(all_tiles, n, w, m, 1, 1, (i,j), unused)
            if ok
                ans = i_to_tn[m[1,1,1]] * i_to_tn[m[1,w,1]] * i_to_tn[m[w,1,1]] * i_to_tn[m[w,w,1]]
                return (ans, m)
            end
        end
    end
    @assert false "no solution"
end

(ans1,m) = part1(test_tiles) 
@assert ans1 == 20899048083289

input = read("input.txt", String)
tiles = read_tiles(input)
(ans1,m) = part1(tiles)
println("PART1: ", ans1)

function matches(image, monst)
    npix = count(c->c=='#', monst)
    ih,iw = size(image)
    mh,mw = size(monst)
    nfound = 0
    for r = 1:(ih-mh+1)
        for c = 1:(iw-mw+1)
            if count(image[r:(r+mh-1),c:(c+mw-1)] .== monst) == npix
                nfound += 1
            end
        end
    end
    nfound
end

function part2(tiles, ans1)
    n = length(tiles)
    w = isqrt(n)
    @assert w * w == n
    (_,tile1) = tiles[1]
    th,tw = size(tile1)
    @assert tw == th
    th -= 2
    tw -= 2

    all_tiles = [gen_all_rot_flip(tm) for (i,tm) in tiles]

    image = Array{Char}(undef, w * tw, w * th)
    for r = 1:w
        for c = 1:w
            tn,tr = m[r,c,1],m[r,c,2]
            tile = all_tiles[tn][tr]
            ulr,ulc = (r-1)*th+1, (c-1)*tw+1
            image[ulr:(ulr+th-1),ulc:(ulc+tw-1)] = tile[2:(2+th-1),2:(2+tw-1)]
        end
    end

    monster_lines = split(read("monst.txt", String), "\n")[1:3]
    monster = reduce(vcat, permutedims.(collect.(monster_lines)))
    npix_monst = count(c->c=='#', monster)

    nmatch = [(i,matches(rot_image, monster))
              for (i,rot_image) in enumerate(gen_all_rot_flip(image))]
    @assert count(t -> t[2] != 0, nmatch) == 1
    (i,nmonst) = filter(t->t[2] != 0, nmatch)[1]
    count(c->c=='#', image) - npix_monst * nmonst
end

println("PART2: ", part2(tiles, ans1))

