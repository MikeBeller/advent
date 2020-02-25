
mutable struct Node
    val::Int64
    next::Union{Node,Nothing}
    prev::Union{Node,Nothing}
end

Node(v::Int64) = Node(v, nothing, nothing)

function insert_next!(n::Node, v::Int64)
    nn = Node(v)
    nn.next = n.next
    nn.prev = n
    n.next = nn
    nn.next.prev = nn
end

function delete_prev!(n::Node)
    n.prev.prev.next = n
    n.prev = n.prev.prev
end

function to_vector(n::Node)
    cm = n.next
    l = [n.val]
    while cm != n
        push!(l, cm.val)
        cm = cm.next
    end
    l
end

function test_list()
    n = Node(1)
    n.next = n
    n.prev = n
    insert_next!(n, 2)
    @assert to_vector(n) == [1, 2]
    n = n.next
    insert_next!(n, 3)
    @assert to_vector(n) == [2, 3, 1]
    n = n.next
    delete_prev!(n)
    @assert to_vector(n) == [3, 1]
end

test_list()

function game(n_players::Int64, max_marble::Int64)::Int64
    scores = zeros(n_players)
    cm = Node(0)
    cm.next = cm
    cm.prev = cm
    for marblenum = 1:max_marble
        playernum = (marblenum-1) % n_players + 1
        if marblenum % 23 != 0
            cm = cm.next
            insert_next!(cm, marblenum)
            cm = cm.next
        else
            scores[playernum] += marblenum
            for i = 1:7
                cm = cm.prev
            end
            scores[playernum] += cm.val
            cm = cm.next
            delete_prev!(cm)
        end
    end
    maximum(scores)
end

@assert game(9, 25) == 32
@assert game(10, 1618) == 8317
@assert game(13, 7999) == 146373

function main()
    ans1 = game(441, 71032)
    println("PART1: ", ans1)

    ans2 = game(441, 7103200)
    println("PART2: ", ans2)
end

main()


