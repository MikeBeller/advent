using DelimitedFiles

function read_data(inpath::String)::Tuple{Array{Int,2},Array{Int,2}}
    r = []
    for line in eachline(inpath)
        m = match(r"position=< *(-?[0-9]+), *(-?[0-9]+)> velocity=< *(-?[0-9]+), *(-?[0-9]+)>", line)
        isnothing(m) && continue
        push!(r, [parse(Int, c) for c in m.captures])
    end
    pos = [r[i][j] for i = 1:length(r), j = 1:2]
    vel = [r[i][j] for i = 1:length(r), j = 3:4]
    (pos, vel)
end

function counts(vs::Vector{Int})::Dict{Int,Int}
    d = Dict{Int,Int}()
    for v in vs
        d[v] = get(d, v, 0) + 1
    end
    d
end

function metric(pos::Array{Int,2})::Int
    THRESH = 4
    score = 0
    ps = sortslices(pos; dims=1)
    i = 1
    lstx = -1
    lsty = -1
    rl = 1
    while i <= size(ps)[1]
        x,y = ps[i, 1], ps[i, 2]
        if x == lstx
            if y == lsty+1
                rl += 1
            else
                rl = 1
            end
            lsty = y
        else
            lstx = x
            lsty = -1
            if rl > THRESH
                score += 1
            end
        end
        i += 1
    end
    #println("returning ", score)
    score
end

# minimum spread
function metric2(pos::Array{Int,2})::Int
    (mnx,mxx) = extrema(pos[:,1])
    (mny,mxy) = extrema(pos[:,2])
    -(mxx-mnx) * (mxy-mny)
end

function sim(pos::Array{Int,2}, vel::Array{Int,2}, n::Int)::Int
    lastmt = typemin(Int)
    for i = 1:n
        pos .+= vel
        mt = metric2(pos)
        println(i, " ", mt)
        #if mt <= lastmt
        if i >= 10000 && i % 1 == 0
            writedlm("snap/snap.$i.csv", pos, ",")
            println(i, " ", mt)
        end
        i == 10400 && break
        lastmt = mt
    end
    lastmt
end

function main()
    #(pos,vel) = read_data("tinput.txt")
    (pos,vel) = read_data("input.txt")
    res = sim(pos, vel, 20000)
    println("PART1: ", res)
end

main()

