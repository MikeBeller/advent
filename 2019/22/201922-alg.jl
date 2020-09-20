
struct Eq
    a::Int128
    b::Int128
    n::Int128
end

# algebraic representation of the operators
D(eq::Eq) = Eq(mod(-eq.a, eq.n), mod(-eq.b-1,eq.n), eq.n)          # D = -x - 1
C(k, eq::Eq) = Eq(eq.a, mod(eq.b-k, eq.n), eq.n)                   # Ck = x - k
I(k, eq::Eq) = Eq(mod(k * eq.a, eq.n), mod(k * eq.b, eq.n), eq.n)  # Ik = k * x

x = Eq(1, 0, 11)
@assert D(D(x)) == x
@assert C(-5, C(5, x)) == x
@assert D(C(3,D(C(3,x)))) == x

eval_eq(eq::Eq, x::Int128) = mod(eq.a * x + eq.b, eq.n)
eval_eq(eq::Eq, x::Int) = eval_eq(eq, Int128(x))

function apply_cmds(cmds, n::Int)
    n = Int128(n)
    eq = Eq(1, 0, n)
    for cmd in cmds
        f = split(cmd, " ")
        if startswith(cmd, "deal into new stack")
            eq = D(eq)
        elseif startswith(cmd, "deal with increment")
            k = parse(Int, strip(f[4]))
            eq = I(k, eq)
        elseif startswith(cmd, "cut")
            k = parse(Int, strip(f[2]))
            eq = C(k, eq)
        end
    end
    eq
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
    eq = apply_cmds(cmds, 10)
    println(eq)
    #@assert t == [9, 2, 5, 8, 1, 4, 7, 0, 3, 6]
    @assert eval_eq(eq, 3) == 8
end

test1()

function part_one()
    cmds = split(strip(read("input.txt", String)), "\n")
    eq = apply_cmds(cmds, 10007)
    println(eq)
    i = eval_eq(eq, 2019)
    i
end

println("PART 1: ", part_one())

function part_two()
    cmds = split(strip(read("input.txt", String)), "\n")
    eq = apply_cmds(cmds, 119315717514047)
    println(eq)
    # Invert the equation algebraicly, and evaluate
    r = mod(mod((2020-eq.b), eq.n) * invmod(eq.a, eq.n), eq.n)
    rr = eval_eq(eq, r)
    println("Ans: $r, reversed: $rr")
    r
end

println("PART 2:")
r = part_two()
println(r)

