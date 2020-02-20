

struct Node
    meta::Vector{Int32}
    kids::Vector{Node}
end

Node() = Node([],[])

function read_tree(ns::Vector{Int32})::Node
    node = Node()
    n_nodes = popfirst!(ns)
    n_meta = popfirst!(ns)

    for i in 1:n_nodes
        child = read_tree(ns)
        push!(node.kids, child)
    end

    for i in 1:n_meta
        push!(node.meta, popfirst!(ns))
    end

    node
end

function sum_meta(node::Node)::Int32
    sum(node.meta) + mapfoldl(sum_meta, +, node.kids; init=Int32(0))
end

function sum_code(node::Node)::Int32
    if length(node.kids) == 0
        sum(node.meta)
    else
        s = Int32(0)
        for ni in node.meta
            if ni > 0 && ni <=length(node.kids)
                s += sum_code(node.kids[ni])
            end
        end
        s
    end
end

function main()
    data = [parse(Int32, s) for s in split(read(open("input.txt"),String))]
    tree = read_tree(data)

    ans1 = sum_meta(tree)
    println("PART1: ", ans1)

    ans2 = sum_code(tree)
    println("PART2: ", ans2)
end

main()



