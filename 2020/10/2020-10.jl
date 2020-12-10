
td1 = [16,10,15,5,1,11,7,19,6,12,4]
td2 = [ 28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3]

function jolt(data)
    js = sort(data)
    pushfirst!(js, 0)
    push!(js, js[end]+3)
    dfs = [js[i+1] - js[i] for i in 1:(length(js)-1)]
    cs = zeros(Int, 3)
    for df in dfs
        cs[df] += 1
    end
    return cs[1], cs[3]
end

function part1(data)
    n1,n3 = jolt(data)
    println("$n1 $n3 $(n1 * n3)")
    return n1 * n3
end

@assert part1(td1) == 35
@assert part1(td2) == 220

read_data(inp) = [parse(Int,s) for s in split(strip(inp), "\n")]
data = read_data(read("input.txt",String))
println("PART1: $(part1(data))")

# this approach blows up for large lists
function paths_recursive(js, i)
    if i == length(js)
        1
    else
        j = i + 1
        s = 0
        while j <= length(js) && js[j] - js[i] < 4
            s += paths_recursive(js, j)
            j += 1
        end
        s
    end
end

# efficient for large lists
function paths(js)
    ps = zeros(Int, length(js))
    ps[end] = 1
    for i = (length(js)-1):-1:1
        j = i + 1
        while j <= length(js) && (js[j] - js[i]) <= 3
            ps[i] += ps[j]
            j += 1
        end
    end
    ps[1]
end

function part2(data)
    js = sort(data)
    pushfirst!(js, 0)
    push!(js, js[end] + 3)
    #paths_recursive(js, 1)
    paths(js)
end

@assert part2(td1) == 8
@assert part2(td2) == 19208

println("PART2: ", part2(data))

