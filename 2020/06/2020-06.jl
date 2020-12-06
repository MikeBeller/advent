
function read_data(inp)
    grss = split(strip(inp), "\n\n")
    groups = []
    for grs in grss
        push!(groups, [Set(p) for p in split(grs, "\n")])
    end
    groups
end

test_data = """
abc

a
b
c

ab
ac

a
a
a
a

b"""

td = read_data(test_data)
@assert length(td) == 5 && td[1] == [Set(['a','b','c'])]

part1(groups) = sum(length(reduce(union, g)) for g in groups)
@assert part1(td) == 11

data = read_data(read("input.txt", String))
println("PART1: ", part1(data))

part2(groups) = sum(length(reduce(intersect, g)) for g in groups)
@assert part2(td) == 6

println("PART2: ", part2(data))
