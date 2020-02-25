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
    xc = counts(pos[:,1])
    #yc = counts(pos[:,2])
    #count(x > 3 for x in values(xc)) * count(y > 3 for y in values(yc))
    count(x > 6 for x in values(xc))
end

function sim(pos::Array{Int,2}, vel::Array{Int,2}, n::Int)::Vector{Int}
    m = Vector{Int}()
    for i = 1:n
        pos .+= vel
        #push!(m, metric(pos))
        mt = metric(pos)
        if mt != 0
            println(i, " ", mt)
        end
        if i == 10118
            @assert mt == 27
            writedlm("snap.csv", pos, ",")
        end
    end
    m
end

function main()
    #(pos,vel) = read_data("tinput.txt")
    #println(pos)
    #println(vel)
    (pos,vel) = read_data("input.txt")
    res = sim(pos, vel, 100000)
    println(res)
end

main()

