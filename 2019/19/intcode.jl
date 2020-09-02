
mutable struct Intcode
    mem::Dict{Int,Int}
    inp::Vector{Int}
    out::Vector{Int}
    pc::Int
    relative_base::Int
    awaiting_input::Bool
end

Intcode(prog::Vector{Int}, input::Vector{Int}) = 
    Intcode( Dict(((i-1)=>v) for (i,v) in enumerate(prog)), input, [], 0, 0, false)

ic = Intcode([1,2,3], [4,5,6])
print(ic)

