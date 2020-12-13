
function read_data(inp)
    (ln1, ln2) = split(strip(inp), "\n")
    dtm = parse(Int, ln1)
    buses = [(s == "x" ? -1 : parse(Int, s)) for s in split(ln2, ",")]
    (dtm, buses)
end

tds = """939\n7,13,x,x,59,x,31,19"""

function part1(data)
    (dtm, all_buses) = data
    buses = [b for b in all_buses if b != -1]
    (bid, delay) = minimum([(b - (dtm % b), b) for b in buses])
    bid * delay
end

td = read_data(tds)
@assert part1(td) == 295

data = read_data(read("input.txt", String))
println("PART1: ", part1(data))

norm(x,b) = (x % b) < 0 ? (x % b) + b : x

function part2(data)
    (dtm, all_buses) = data
    poly = [(b, norm(-i+1,b)) for (i,b) in enumerate(all_buses) if b != -1]
    (m,r) = poly[1]
    for (b,i) in poly[2:end]
        while r % b != i
            r += m
        end
        m *= b
    end
    r
end

@assert part2(td) == 1068781
@assert part2(read_data("0\n17,x,13,19")) == 3417
@assert part2(read_data("0\n67,7,59,61")) == 754018
@assert part2(read_data("0\n67,x,7,59,61")) == 779210
@assert part2(read_data("0\n67,7,x,59,61")) == 1261476
@assert part2(read_data("0\n1789,37,47,1889")) == 1202161486

println("PART2: ", part2(data))

