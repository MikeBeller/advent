
function partition(ts, sep)
    r = Vector{Vector{String}}([[]])
    for t in ts
        if t == sep
            push!(r, [])
        else
            push!(r[end], t)
        end
    end
    r
end

parse_seq_seq(ts) = [[parse(Int,s) for s in sub]
                     for sub in partition(ts, "|")]

@assert parse_seq_seq(["2", "1", "3"]) == [[2, 1, 3]]
@assert parse_seq_seq(["2", "1", "|", "3"]) == [[2, 1], [3]]

function parse_rule(ts::Vector{<:AbstractString})::Rule
    if startswith(ts[1], '"')
        ts[1][2:end-1]
    else
        parse_seq_seq(ts)
    end
end
    
const Rule = Union{AbstractString,Vector{Vector{Int}}}

function read_rules(inp)
    rules = Dict{Int,Rule}()
    for line in split(strip(inp), "\n")
        f = split(line, " ")
        n = parse(Int, f[1][1:end-1])
        rules[n] = parse_rule(f[2:end])
    end
    rules
end

function match_seq(rules::Dict{Int,Rule}, seq::Vector{Int}, str::AbstractString)::Tuple{Bool,AbstractString}
    println("SEQ: ", seq)
    for ri in seq
        (a, str) = match_rule(rules, rules[ri], str)
        println(rules[ri], ": ", a, " ", str)
        if !a
            return (false, "")
        end
    end
    (str=="", str)
end

function match_rule(rules::Dict{Int,Rule}, rule::Rule, str::AbstractString)::Tuple{Bool,AbstractString}
    if typeof(rule) <: AbstractString
        if startswith(str, rule)
            (true, str[length(rule):end])
        else
            (false, "")
        end
    else
        s = str
        for seq in rule
            a,s = match_seq(rules, seq, s)
            if !a
                return (false, "")
            end
        end
        (true, s)
    end
end

rules = read_rules("""
0: 1 2
1: "a"
2: 1 3 | 3 1
3: "b"
""")

@assert match_rule(rules, "a", "a")[1]
@assert match_rule(rules, rules[0], "aab") == (true, "")
