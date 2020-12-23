
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
    for ri in seq
        (a, str) = match_rule(rules, rules[ri], str)
        if !a
            return (false, "")
        end
    end
    (true, str)
end

function match_rule(rules::Dict{Int,Rule}, rule::Rule, str::AbstractString)::Tuple{Bool,AbstractString}
    if typeof(rule) <: AbstractString
        if startswith(str, rule)
            (true, str[(length(rule)+1):end])
        else
            (false, "")
        end
    else  # "any"
        for seq in rule
            a,s = match_seq(rules, seq, str)
            if a
                return (a, s)
            end
        end
        (false, str)
    end
end

rules = read_rules("""
0: 1 2
1: "a"
2: 1 3 | 3 1
3: "b"
""")

@assert match_rule(rules, rules[1], "a") == (true, "")
@assert match_rule(rules, rules[2], "ab") == (true, "")
@assert match_rule(rules, rules[0], "aba") == (true, "")
@assert match_rule(rules, rules[0], "aab") == (true, "")

function part1(inp)
    rules_str,msgs_str = split(strip(inp), "\n\n")
    rules = read_rules(rules_str)
    tests = split(strip(msgs_str), "\n")
    num_ok = 0
    for test in tests
        (r,s) = match_rule(rules, rules[0], test)
        if r && s == ""
            num_ok += 1
        end
    end
    num_ok
end

tds = """
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb"""

@assert part1(tds) == 2
input = read("input.txt", String)
println("PART1: ", part1(input))

# Assumes the 0 rule is 8 11, and 8 is 42 | 42 8,
# and 11 is 42 31 | 42 11 31
# Also assumes 8 and 11 do not exist in other rules
# Thus you just have to look for any rule
#     with i x 42, followed by j x 42 followed by j x 31
#     for any i,j.  Pick i, j equal to max test string length?
# We will set max i and j to "HACK" and hope for the best
HACK = 30
function part2(inp)
    rules_str,msgs_str = split(strip(inp), "\n\n")
    rules = read_rules(rules_str)
    tests = split(strip(msgs_str), "\n")
    delete!(rules, 0)
    delete!(rules, 8)
    delete!(rules, 11)
    num_ok = 0
    for test in tests
        rule = []
        r = false
        s = ""
        for i in 1:HACK, j in 1:HACK
            rule = vcat(fill(42, i), fill(42, j), fill(31,j))
            (r,s) = match_rule(rules, [rule], test)
            if r && s == ""
                num_ok += 1
                break
            end
        end
    end
    num_ok
end

t2s = """
42: 9 14 | 10 1
9: 14 27 | 1 26
10: 23 14 | 28 1
1: "a"
11: 42 31
5: 1 14 | 15 1
19: 14 1 | 14 14
12: 24 14 | 19 1
16: 15 1 | 14 14
31: 14 17 | 1 13
6: 14 14 | 1 14
2: 1 24 | 14 4
0: 8 11
13: 14 3 | 1 12
15: 1 | 14
17: 14 2 | 1 7
23: 25 1 | 22 14
28: 16 1
4: 1 1
20: 14 14 | 1 15
3: 5 14 | 16 1
27: 1 6 | 14 18
14: "b"
21: 14 1 | 1 14
25: 1 1 | 1 14
22: 14 14
8: 42
26: 14 22 | 1 20
18: 15 15
7: 14 5 | 1 21
24: 14 1

abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaaaabbaaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
babaaabbbaaabaababbaabababaaab
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba"""

@assert part1(t2s) == 3
@assert part2(t2s) == 12
println("PART2: ", part2(input))

