function read_input()
    [parse(Int32,line) for line in eachline("input.txt")]
end

function part_one(data)
    sum(data)
end

function part_two(data)
    seen = Dict{Int32,Bool}()
    s = 0
    for i in Iterators.cycle(data)
        s += i
        haskey(seen, s) && return s
        seen[s] = true
    end
end

function main()
    data = read_input()
    ans1 = part_one(data)
    println("PART1:", ans1)
    
    ans2 = part_two(data)
    println("PART2:", ans2)
end

main()