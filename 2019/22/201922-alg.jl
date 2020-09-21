
struct Eq
    a::BigInt
    b::BigInt
    n::BigInt
end

# algebraic representation of the operators
D(eq::Eq) = Eq(mod(-eq.a, eq.n), mod(-eq.b-1,eq.n), eq.n)          # D = -x - 1
C(k, eq::Eq) = Eq(eq.a, mod(eq.b-k, eq.n), eq.n)                   # Ck = x - k
I(k, eq::Eq) = Eq(mod(k * eq.a, eq.n), mod(k * eq.b, eq.n), eq.n)  # Ik = k * x

eql(e1, e2) = e1.a == e2.a && e1.b == e2.b && e1.n == e2.n

x = Eq(1, 0, 11)
println(D(D(x)))
@assert eql(D(D(x)), x)
@assert eql(C(-5, C(5, x)), x)
@assert eql(D(C(3,D(C(3,x)))), x)

eval_eq(eq::Eq, x::BigInt) = mod(eq.a * x + eq.b, eq.n)
eval_eq(eq::Eq, x::Int) = eval_eq(eq, BigInt(x))

function apply_cmds(cmds, n::Int)
    n = BigInt(n)
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
    # Compute the polynomial for a single application
    cmds = split(strip(read("input.txt", String)), "\n")
    eq = apply_cmds(cmds, 119315717514047)
    println(eq)

    # Now what is involved in iterating the polynomial k times
    #  x[1] = ax[0] + b, x[2] = a^2x[0] + ab +b, x[3] =...
    #  in general
    #    x[k] = a^k * x0 + b(1 + a + a^2 + ... + a^(k-1))
    #
    #  thus x[k] = a^k*x0 + b * (a^k - 1)/(a - 1)
    #
    #  We are given X[k] as 2020 and want to find x[0], so invert the equation:
    #
    #  X[0] = a^(-k) * (2020 - b*(a^k - 1) / (a - 1))
    #
    xk = BigInt(2020)
    k = BigInt(101741582076661)
    a = eq.a
    b = eq.b
    n = eq.n
    x0 = powermod(a, -k, n) * (xk - b * (powermod(a, k, n) - 1) * invmod(a - 1, n))
    x0 = mod(x0, n)

    # check it forward:
    xk = x0 * powermod(a, k, n) + b * (powermod(a, k, n) - 1) * invmod(a - 1, n)
    xk = mod(xk, n)
    println("FORWARD: $x0 BACK: $xk")
    @assert xk == BigInt(2020)
    x0
end

println("PART 2:")
r = part_two()
println(r)

