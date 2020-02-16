function checksum(label)
    freq = Dict{Char,Int32}()
    for c in label
        freq[c] = get(freq, c, 0) + 1
    end
    vs = values(freq)
    [any(vs .== 2), any(vs .== 3)]
end

function part_one(data)
    a = hcat(collect(checksum(label) for label in data)...)
    prod(sum(r) for r in eachrow(a))
end

function dist(as, bs)
    sum(as .!= bs)
end

function part_two(data)
    ds = [collect(d) for d in data]
    for (i,as) in enumerate(ds)
        for bs in ds[i+1:end]
            if dist(as, bs) == 1
                return join([a for (a,b) in zip(as,bs) if a == b])
            end
        end
    end
end

function part_two_fast(data)
    for i in 1:length(data[1])
        seen = Dict{String,Bool}()
        for ds in data
            k = ds[1:i-1] * ds[i+1:end]
            if haskey(seen,k)
                return k
            end
            seen[k] = true
        end
    end
end

function main()
    data = collect(eachline("input.txt"))
    #data = collect(eachline("test.txt"))
    ans1 = part_one(data)
    println("PART1:", ans1)
    
    ans2 = part_two(data)
    println("PART2:", ans2)
    
    ans2f = part_two_fast(data)
    println("PART2F:", ans2f)
end

main()
