

D(n, i) = mod(-(i+1), n)
C(k, n, i) = mod((i - k), n)
I(k, n, i) = mod(i * k, n)

@assert D(10, 3) == 6
@assert C(3, 10, 3) == 0
@assert C(-4, 10, 3) == 7
@assert I(3, 10, 3) == 9
@assert I(3, 10, 7) == 1

function apply_cmds(n, i, cmds)
    for cmd in cmds
        f = split(cmd, " ")
        if startswith(cmd, "deal into new stack")
            i = D(n, i)
        elseif startswith(cmd, "deal with increment")
            k = parse(Int, strip(f[4]))
            i = I(k, n, i)
        elseif startswith(cmd, "cut")
            k = parse(Int, strip(f[2]))
            i = C(k, n, i)
        end
        println("I: $i CMD: $cmd")
    end
    i
end

function test1()
    cmds = [
            "deal into new stack",
            "cut -2",
            "deal with increment 7",
            "cut 8",
            "cut -4",
            "deal with increment 7",
            "cut 3",
            "deal with increment 9",
            "deal with increment 3",
            "cut -1",]
    t = apply_cmds(10, 3, cmds)
    println(t)
    #@assert t == [9, 2, 5, 8, 1, 4, 7, 0, 3, 6]
    @assert t == 8
end

test1()

function part_one()
    cmds = split(strip(read("input.txt", String)), "\n")
    i = apply_cmds(10007, 2019, cmds)
    i
end

println("PART 1: ", part_one())

