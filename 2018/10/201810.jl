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

# minimum spread
function metric(pos::Array{Int,2})::Int
    (mnx,mxx) = extrema(pos[:,1])
    (mny,mxy) = extrema(pos[:,2])
    -(mxx-mnx) * (mxy-mny)
end

function sim(pos::Array{Int,2}, vel::Array{Int,2}, n::Int)::Int
    lastmt = typemin(Int)
    for i = 1:n
        pos .+= vel
        mt = metric(pos)
        if mt <= lastmt
            pos .-= vel
            j = i - 1
            writedlm("snap.$j.csv", pos, ",")
            println(i, " ", mt)
            break
        end
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

