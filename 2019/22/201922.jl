

function deal_new(s::Vector{Int})::Vector{Int}
    reverse(s)
end

function cut_n(n::Int, s::Vector{Int})::Vector{Int}
    circshift(s, -n)
end

function deal_increment(n::Int, s::Vector{Int})::Vector{Int}
    t = zeros(length(s))
    o = 0
    for v in s
        t[o+1] = v
        o = (o + n) % length(s)
    end
    t
end

@assert (deal_new(collect(0:9))) == [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
@assert (cut_n(3, collect(0:9))) == [3, 4, 5, 6, 7, 8, 9, 0, 1, 2]
@assert (cut_n(-4, collect(0:9))) == [6, 7, 8, 9, 0, 1, 2, 3, 4, 5]
@assert (deal_increment(3, collect(0:9))) == [0, 7, 4, 1, 8, 5, 2, 9, 6, 3]

function apply_cmds(s, cmds)
    t = s
    for cmd in cmds
        f = split(cmd, " ")
        if startswith(cmd, "deal into new stack")
            t = deal_new(t)
        elseif startswith(cmd, "deal with increment")
            n = parse(Int, strip(f[4]))
            t = deal_increment(n, t)
        elseif startswith(cmd, "cut")
            n = parse(Int, strip(f[2]))
            t = cut_n(n, t)
        end
    end
    t
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
    t = apply_cmds(collect(0:9), cmds)
    @assert t == [9, 2, 5, 8, 1, 4, 7, 0, 3, 6]

    for i in 1:length(cmds)
        t = apply_cmds(collect(0:9), cmds[1:i])
        n = findfirst(x->x==3, t) - 1
        println("I: $n T: $t CMD: $(cmds[i])")
    end
end

test1()

function part_one()
    cmds = split(strip(read("input.txt", String)), "\n")
    t = apply_cmds(collect(0:10006), cmds)
    findfirst(x->x==2019, t) - 1
end

println("PART 1: ", part_one())

