
function nondecreasing(ds::Array{Int64,1})::Bool
    for i = 1:5
        if ds[i+1] < ds[i]
            return false
        end
    end
    return true
end

function runlengths(ns::Array{Int64,1})::Array{Int64,1}
    lns = Int[1]
    for i = 2:length(ns)
        if ns[i] != ns[i-1]
            push!(lns, 1)
        else
            lns[end] += 1
        end
    end
    return lns
end

function valid(p::Int)::Bool
    ds = reverse(digits(p))
    if ! nondecreasing(ds)
        return false
    end
    lns = runlengths(ds)
    any(i -> i > 1, lns)
end

@assert valid(111111)
@assert !valid(123450)
@assert !valid(123789)

function partone(s::Int, e::Int)::Int
    c = 0
    for n = s:e
        if valid(n)
            c += 1
        end
    end
    c
end

function valid2(p::Int)::Bool
    ds = reverse(digits(p))
    if ! nondecreasing(ds)
        return false
    end
    lns = runlengths(ds)
    any(i -> i == 2, lns)
end

@assert valid2(112233)
@assert !valid2(123444)
@assert valid2(111122)

function parttwo(s::Int, e::Int)::Int
    c = 0
    for n = s:e
        if valid2(n)
            c += 1
        end
    end
    c
end

s = 136818
e = 685979
println(partone(s,e))
println(parttwo(s,e))

