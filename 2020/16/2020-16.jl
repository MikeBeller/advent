import Hungarian

function read_data(inp)
    mode = "RULES"
    rules = Dict{String,Tuple{Int,Int,Int,Int}}()
    mine = Vector{Int}()
    nearby = Vector{Vector{Int}}()
    for line in split(strip(inp), "\n")
        if startswith(line, "your ticket:")
            mode = "MINE"
            continue
        elseif startswith(line, "nearby tickets:")
            mode = "NEARBY"
            continue
        elseif line == ""
            continue
        end
        if mode == "RULES"
            m = match(r"([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)", line)
            if m != nothing
                (a, b, c, d) = [parse(Int, x) for x in m.captures[2:5]]
                rules[m.captures[1]] = (a, b, c, d)
            end
        elseif mode == "MINE"
            mine = [parse(Int,x) for x in split(line, ",")]
        elseif mode == "NEARBY"
            push!(nearby, [parse(Int,x) for x in split(line, ",")])
        end
    end
    (rules, mine, nearby)
end

td_string = """
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12"""

function is_valid(ranges, v)
    (a, b, c, d) = ranges
    (a <= v <= b) || (c <= v <= d)
end

function check_tickets(rules, nearby)
    error = 0
    valid = Vector{Vector{Int}}()
    for ticket in nearby
        any_bad = false
        for v in ticket
            if all(rng -> !is_valid(rng, v), values(rules))
                error += v
                any_bad = true
            end
        end
        if !any_bad
            push!(valid, ticket)
        end
    end
    error, valid
end

part1((rules,mine,nearby)) = check_tickets(rules, nearby)[1]

td = read_data(td_string)
@assert part1(td) == 71

data = read_data(read("input.txt", String))

println("PART1: ", part1(data))

td2_string = """
class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9"""

# Create a matrix of potential column/rule assignments
function assignment_matrix(rules, tickets)
    ncols = length(tickets[1])
    @assert all([length(v) == ncols for v in tickets])
    rule_index = Dict((rname,i) for (i,(rname,rng)) in enumerate(rules))
    m = zeros(Int,(length(rules), ncols))
    canbes = []
    for col = 1:ncols
        canbe = reduce(intersect, 
            [Set([r for (r,rng) in rules if is_valid(rng, t[col])])
             for t in tickets])
        for rname in canbe
            m[rule_index[rname], col] = 1
        end
    end
    m
end

# Determine the legal column order given the rules and tickets
function column_order(rules, tickets)
    m = assignment_matrix(rules, tickets)
    @assert size(m) == (length(rules), length(tickets[1]))
    ncols = length(rules)
    row_to_name = Dict((i,rname) for (i,(rname,rng)) in enumerate(rules))
    m2 = -m
    match = Hungarian.munkres(m2)
    mm = Matrix(match)
    order = [row_to_name[findfirst(x->x==2, mm[:,c])] for c in 1:ncols]
    order
end

td2 = read_data(td2_string)
@assert column_order(td2[1], td2[3]) == ["row", "class", "seat"]

function part2(data)
    (rules_dict, mine, nearby) = data
    _, valid_tickets = check_tickets(rules_dict, nearby)
    rules = [(k,v) for (k,v) in rules_dict]
    order = column_order(rules, valid_tickets)
    (rules_dict, mine, nearby) = data
    prod(mine[i] for i in 1:length(order) if startswith(order[i], "departure"))
end

println("PART2: ", part2(data))
