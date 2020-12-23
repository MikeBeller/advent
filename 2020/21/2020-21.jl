import Combinatorics

tds = """
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)"""

function read_data(inp)
    r = []
    for line in split(strip(inp), "\n")
        line = line[1:end-1]  # final )
        line = replace(line, "," => "")
        ings,algs = split(line, "(contains ")
        push!(r, (Set(split(ings)), Set(split(algs))))
    end
    r
end

validate_rule((ings,algs), m) = length(setdiff(algs, Set([m[ing] for ing in ings if haskey(m, ing)]))) == 0

validate_rules(rules, m) = all(validate_rule(rule, m) for rule in rules)

function solve(rules, i, m)
    #println("WORKING RULE $i with $m")
    if !validate_rules(rules[1:i-1], m)
        #println("INVALID")
        return false, m
    end
    if i > length(rules)
        return true, m
    end

    (ings, algs) = rules[i]
    algs = setdiff(algs, values(m))
    #println("In rule $i ings $ings algs $algs")
    if length(algs) == 0
        return solve(rules, i+1, m)
    end
    for cs in collect(Combinatorics.combinations(collect(ings), length(algs)))
        #println("TRYING: $cs ")
        as = collect(algs)
        m2 = copy(m)
        for (n,ing) in enumerate(cs)
            m2[ing] = as[n]
            #println("$ing = $(as[n])")
        end
        ok,m3 = solve(rules, i+1, m2)
        if ok
            return true, m3
        end
    end
    false, m
end


function part1(rules)
    m = Dict()
    ok,m = solve(rules, 1, m)
    #println("OK: $ok M: $m")
    all_ings = reduce(union, [ings for (ings,algs) in rules])
    unassigned = setdiff(all_ings, Set(keys(m)))
    count(i -> i in unassigned, reduce(vcat, [collect(ings) for (ings, algs) in rules]))
end

test_rules = read_data(tds)
@assert validate_rule(test_rules[1], Dict("mxmxvkd" => "fish", "kfcds" => "dairy"))
@assert validate_rules(test_rules, Dict("mxmxvkd" => "dairy", "sqjhc" => "fish", "fvjkl" => "soy"))
@assert part1(test_rules) == 5

rules = read_data(read("input.txt", String))
println("PART1: ", part1(rules))
