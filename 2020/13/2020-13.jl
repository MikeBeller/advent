
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

function part2(data)
    (dtm, all_buses) = data
    base = [(b-i+1, i) for (i,b) in enumerate(all_buses) if b != -1]
end

println(part2(td))

