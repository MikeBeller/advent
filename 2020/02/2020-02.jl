
function read_data(inp)
    inp = strip(inp)
    rx = r"^(\d+)-(\d+) ([a-z]): ([a-z]+)$"
    r = []
    for line in split(inp, "\n")
        println(line)
        m = match(rx, line)
        @assert m != nothing
        push!(r, (parse(Int, m.captures[1]),
                  parse(Int, m.captures[2]),
                  m.captures[3][1],
                  m.captures[4]))
    end
    r
end

test_data = """
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
"""

@assert length(read_data(test_data)) == 3

function part1(inp)
    ok = 0
    for (mn,mx,ch,pw) in read_data(inp)
        cc = count(c -> (c == ch), pw)
        ok += (cc >= mn && cc <= mx)
    end
    ok
end

@assert part1(test_data) == 2
inp = read("input.txt", String)
println("PART1: ", part1(inp))

function part2(inp)
    ok = 0
    for (p1,p2,ch,pw) in read_data(inp)
        cc = (pw[p1] == ch) + (pw[p2] == ch)
        ok += (cc == 1)
    end
    ok
end

@assert part2(test_data) == 1
println("PART2: ", part2(inp))
