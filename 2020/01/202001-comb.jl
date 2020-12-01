using Combinatorics

part1(data) = Iterators.filter( x->sum(x)==2020, combinations(data,2)) |> first |> prod
@assert part1([1721, 979, 366, 299, 675, 1456]) == 514579

part2(data) = Iterators.filter( x->sum(x)==2020, combinations(data,3)) |> first |> prod
@assert part2([1721, 979, 366, 299, 675, 1456]) == 241861950

data = [parse(Int,s) for s in readlines("input.txt")]
println("Part1: ", part1(data))
println("Part2: ", part2(data))
