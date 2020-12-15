

function part1(data, n)
    a = zeros(Int,n)
    last = -1
    for i = 1:n
        if i <= length(data)
            d = data[i]
        else
            d = a[last+1] == 0 ? 0 : i-1 - a[last+1]
        end
        if last != -1
            a[last+1] = i-1
        end
        #println("$i $d $a")
        last = d
    end
    last
end

@assert part1([0, 3, 6], 9) == 4
println("PART1: ", part1([0,14,6,20,1,4], 2020))
println("PART2: ", part1([0,14,6,20,1,4], 30000000))

