
ctoi(c::Char)::Int = if (c == 'F' || c == 'L') 0 else 1 end
decode(s::AbstractString)::Int = sum(2^(10-i)*ctoi(c) for (i,c) in enumerate(s))
row(n) = n >> 3
col(n) = n & 0b111

@assert (d = decode("FBFBBFFRLR");  d == 357 && row(d) == 44 && col(d) == 5)
@assert decode("BFFFBBFRRR") == 567
@assert decode("FFFBBBFRRR") == 119

data = read("input.txt",String) |> split

part1(data) = maximum(decode(s) for s in data)
println("PART1: ", part1(data))

function part2(data)
    ds = sort(collect(decode(s) for s in data))
    for i = 1:length(ds)
        if ds[i+1] - ds[i] != 1
            return ds[i] + 1
        end
    end
    @assert false
end

println("PART2: ", part2(data))

