const Item = NamedTuple{(:g, :s, :e), Tuple{Int32, Int32, Int32}}

function read_input()::Vector{Item}
    data = []
    g = -1
    for line in sort(collect(eachline("input.txt")))
        f = split(line, " ")
        t = parse(Int32, f[2][end-2:end-1])
        if f[3] == "Guard"
            g = parse(Int32, f[4][2:end])
        elseif f[3] == "falls"
            push!(data, (g=g, s=t, e=60))
        elseif f[3] == "wakes"
            o = data[end]
            data[end] = (g=g, s=o.s, e=t)
        end
    end
    data
end

function minute_map(data::Vector{Item})::Dict{Int32, Vector{Int32}}
    gmins = Dict{Int32, Vector{Int32}}()
    for d in data
        get!(()->zeros(Int32,60), gmins, d.g)
        gmins[d.g][(d.s+1):d.e] .+= 1
    end
    gmins
end

function part1(data::Vector{Item})
    gmins = minute_map(data)
    gtot = Dict(k => sum(v) for (k,v) in gmins)
    _,mxgi = findmax(gtot)
    _,mxminute = findmax(gmins[mxgi])
    mxgi * (mxminute-1)
end

function part2(data::Vector{Item})
    gmins = minute_map(data)
    mxs = Dict(g=>maximum(v) for (g,v) in gmins)
    _,mxg = findmax(mxs)
    _,mxm = findmax(gmins[mxg])
    mxm -= 1  # adjust for 1-based arrays
    mxg * mxm
end

function main()
    data = read_input()
    ans1 = part1(data)
    println("PART1: ", ans1)

    ans2 = part2(data)
    println("PART2: ", ans2)
end

main()
