
data = [parse(Int, s) for s in readlines("input.txt")]
println("PART1: ", sum((div(m, 3) - 2) for m in data))

function fuel(m)
    f = div(m, 3) - 2
    if f <= 0
        0
    else
        f + fuel(f)
    end
end

println("PART2: ", sum(fuel(m) for m in data))

