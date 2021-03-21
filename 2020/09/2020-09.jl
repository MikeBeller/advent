
read_data(s) = [parse(Int, f) for f in split(strip(s),"\n")]

function valid(ws, x)
    for i = 1:(length(ws)-1)
        for j = i:(length(ws))
            if ws[i] + ws[j] == x
                return true
            end
        end
    end
    false
end

function first_invalid(xs, wn)
    ws = xs[1:wn]
    for i = (wn+1):(length(xs))
        if !valid(ws, xs[i])
            return xs[i]
        end
        ws = xs[(i-wn+1):i]
    end
    @assert false "not found"
end

td = [35,20,15,25,47,40,62,55,65,95,102,117,150,182,127,219,299,277,309,576]

@assert first_invalid(td, 5) == 127

part1(data) = first_invalid(data, 25)

function find_weakness(xs, target)
    for i = 1:(length(xs)-1)
        sm = xs[i]
        j = i+1
        while sm < target
            sm += xs[j]
            j += 1
        end
        if sm == target
            (mn,mx) = extrema(xs[i:(j-1)])
            return mn + mx
        end
    end
end

@assert find_weakness(td, 127) == 62

data = read_data(read("input.txt", String))
ans1 = @time part1(data)
println("PART1: ", ans1)
part2(data) = @time find_weakness(data, ans1)
println("PART2: ", part2(data))
