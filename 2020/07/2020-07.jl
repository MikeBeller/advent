

test_data = """
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags."""

function parse_rule(line)
    f = split(line)
    key = "$(f[1]) $(f[2])"
    kids = Vector{Tuple{Int,String}}()
    @assert f[3] == "bags" && f[4] == "contain"
    if f[5] != "no"
        rs = f[5:end]
        while length(rs) > 0
            @assert length(rs) >= 4
            num = parse(Int, rs[1])
            col = "$(rs[2]) $(rs[3])"
            push!(kids, (num, col))
            rs = rs[5:end]
        end
    end
    (key, kids)
end

@assert parse_rule("vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.") == ("vibrant plum", [(5, "faded blue"), (6, "dotted black")])
@assert parse_rule("faded blue bags contain no other bags.") == ("faded blue", [])

read_data(inp) = [parse_rule(line) for line in split(strip(inp), "\n")]

td = read_data(test_data)

function part1(data)
    g = Dict{String,Set{String}}()
    for (parentcolor,kids) in data
        for (num,kidcolor) in kids
            push!(get!(g, kidcolor, Set()), parentcolor)
        end
    end
    parents = Set{String}()
    kids = ["shiny gold"]
    while length(kids) > 0
        kids2 = []
        for kidcolor in kids
            ps = get(g, kidcolor, [])
            append!(kids2, ps)
            union!(parents, ps)
        end
        kids = kids2
    end
    parents
end

@assert length(part1(td)) == 4

data = read_data(read("input.txt", String))
println("PART1: ", length(part1(data)))

function nbags(g, col)
    kids = g[col]
    length(kids) == 0 ? 1 : 1 + sum(n * nbags(g, c) for (n,c) in kids)
end

function part2(data)
    g = Dict((k => v) for (k,v) in data)
    nbags(g, "shiny gold") - 1
end

@assert part2(td) == 32

test_data2 = """
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags."""

@assert part2(read_data(test_data2)) == 126

println("PART2: ", part2(data))

