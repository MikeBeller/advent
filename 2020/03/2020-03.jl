
function read_data(inp)
    lines = split(strip(inp), "\n")
    reduce(vcat, permutedims.(collect.(lines)))
end

testdata = """
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#"""

@assert size(read_data(testdata)) == (11,11)

function checkslope(m, dx, dy)
    (h,w) = size(m)
    x = y = 1
    trees = 0
    while true
        x = ((x + dx) - 1) % w + 1
        y += dy
        trees += if m[y,x] == '#' 1 else 0 end
        if y == h break end
    end
    trees
end

inp = read("input.txt", String)
m = read_data(inp)
part1(m) = checkslope(m, 3, 1)
@assert part1(read_data(testdata)) == 7

println("PART1: ", part1(m))

part2(m) = prod(checkslope(m, dx, dy) for (dx,dy) in [[1,1], [3,1], [5,1], [7,1], [1,2]])
println("PART2: ", part2(m))

