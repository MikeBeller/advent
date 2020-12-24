tds = """
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)"""

function read_data(inp)
    r = []
    for line in split(strip(inp), "\n")
        line = line[1:end-1]  # final )
        line = replace(line, "," => "")
        ings,algs = split(line, "(contains ")
        push!(r, (Set(split(ings)), Set(split(algs))))
    end
    r
end

function possible_assignments(rules)
    all_algs = reduce(union, (algs for (ings,algs) in rules))
    can_be = Dict{String,Set{String}}()
    for alg in all_algs
        can_be[alg] = reduce(intersect, (is for (is,as) in rules if alg in as))
    end
    can_be
end

function part1(rules)
    can_be = possible_assignments(rules)
    all_used_ings = reduce(union, values(can_be))
    sm = 0
    for (ings,algs) in rules
        sm += count(i->!(i in all_used_ings), ings)
    end
    sm
end

test_rules = read_data(tds)
@assert part1(test_rules) == 5

rules = read_data(read("input.txt", String))
println("PART1: ", part1(rules))

function part2(rules)
    can_be = possible_assignments(rules)
    println(can_be)
end

println("PART2: ", part2(test_rules))
