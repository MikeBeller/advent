
function parse_expr(line)
    fields = split(strip(line), " ")
    toks = []
    for field in fields
        f = field
        while startswith(f, "(")
            push!(toks, :lpar)
            f = f[2:end]
        end

        rpars = []
        while endswith(f, ")")
            push!(rpars, :rpar)
            f = f[1:end-1]
        end

        if f == "+"
            push!(toks, :plus)
        elseif f == "*"
            push!(toks, :times)
        else
            push!(toks, parse(Int, f))
        end

        append!(toks, rpars)

    end
    toks
end

td = [
      ("1 + 2 * 3 + 4 * 5 + 6", 71),
      ("2 * 3 + (4 * 5)", 26),
      ("5 + (8 * 3 + 9 + 3 * 4 * 3)", 437),
      ("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 12240),
      ("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 13632),]

function dijkstra(toks, precedence)
    out_q = []
    op_st = []
    for tok in toks
        if typeof(tok) == Int64
            push!(out_q, tok)
        elseif tok == :lpar
            push!(op_st, tok)
        elseif tok == :rpar
            while op_st[end] != :lpar
                push!(out_q, pop!(op_st))
            end
            if length(op_st) != 0 && op_st[end] == :lpar
                pop!(op_st)
            end
        elseif tok == :plus || tok == :times
            while (length(op_st) != 0
                   && (op_st[end] == :plus || op_st[end] == :times)
                   && (precedence(op_st[end]) >= precedence(tok)))
                push!(out_q, pop!(op_st))
            end
            push!(op_st, tok)
        end
    end
    while length(op_st) != 0
        push!(out_q, pop!(op_st))
    end
    out_q
end

@assert dijkstra(parse_expr(td[2][1]),t->0) == [2, 3, :times, 4, 5, :times, :plus]

function eval_rpn(rpn)
    st = []
    for tok in rpn
        if typeof(tok) == Int64
            push!(st, tok)
        elseif tok == :plus
            push!(st, pop!(st) + pop!(st))
        elseif tok == :times
            push!(st, pop!(st) * pop!(st))
        end
    end
    @assert length(st) == 1
    st[1]
end

function part1(expr_str)
    expr = parse_expr(expr_str)
    rpn = dijkstra(expr, t->0)  # no precedence
    eval_rpn(rpn)
end

for (estr,ans) in td
    @assert part1(estr) == ans
end

inp = strip(read("input.txt", String))
println("PART1: ", sum(part1(exs) for exs in split(inp,"\n")))

td2 = [
       ("1 + (2 * 3) + (4 * (5 + 6))", 51),
      ("2 * 3 + (4 * 5)", 46),
      ("5 + (8 * 3 + 9 + 3 * 4 * 3)", 1445),
      ("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 669060),
      ("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 23340),]

function part2(expr_str)
    expr = parse_expr(expr_str)
    rpn = dijkstra(expr, t -> t == :plus ? 1 : 0)  # precedence to plus
    eval_rpn(rpn)
end

for (estr,ans) in td2
    @assert part2(estr) == ans
end

println("PART2: ", sum(part2(exs) for exs in split(inp,"\n")))
