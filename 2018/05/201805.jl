
function cancels(a, b)
    abs(a - b) == 32
end

function react(instr)
    cs = map(Int8, collect(instr))
    while true
        buf = Vector{Int8}()
        while length(cs) >= 2 && cancels(cs[1], cs[2])
            cs = cs[3:end]
        end
        length(cs) == 0 && return ""
        for r = 1:length(cs)
            if length(buf) == 0
                push!(buf, cs[r])
            elseif cancels(buf[end], cs[r])
                pop!(buf)
            else
                push!(buf, cs[r])
            end
        end
        if length(buf) == length(cs)
            return join(map(Char, buf), "")
        end
        cs = buf
    end
end

@assert react("aA") == ""
@assert react("aAb") == "b"
@assert react("aAbB") == ""
@assert react("aAxbByz") == "xyz"
@assert react("aBbAyz") == "yz"

function part2(data)
    r = []
    for c in "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        new = filter(ch -> ch!=c&&ch!=(c+32), data)
        len = length(react(new))
        push!(r, (len, c))
    end
    minimum(r)
end

function main()
    data = chomp(String(read("input.txt")))
    r = react(data)
    ans1 = length(r)
    println("PART1: ", ans1)

    ans2 = part2(data)
    println("PART2: ", ans2)
end

main()
