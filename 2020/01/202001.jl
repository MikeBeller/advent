

function part1(data)
    ln = length(data)
    for i in 1:(ln-1)
        for j in (i+1):ln
            if data[i] + data[j] == 2020
                println(data[i], " ", data[j])
                return data[i] * data[j]
            end
        end
    end
    @assert false
end

@assert part1([1721, 979, 366, 299, 675, 1456]) == 514579

data = [parse(Int,s) for s in readlines("input.txt")]
ans1 = part1(data)
println("Part1: ", ans1)

function part2(data)
    ln = length(data)
    for i in 1:(ln-2)
        for j in (i+1):(ln-1)
            for k in (j+1):ln
                if data[i] + data[j] + data[k] == 2020
                    println(data[i], " ", data[j], " ", data[k])
                    return data[i] * data[j] * data[k]
                end
            end
        end
    end
    @assert false
end

@assert part2([1721, 979, 366, 299, 675, 1456]) == 241861950

ans2 = part2(data)
println("Part2: ", ans2)

