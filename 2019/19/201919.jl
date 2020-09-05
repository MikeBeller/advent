
include("intcode.jl")

function check_coord(prog, x::Int, y::Int)::Int
    if x < 0 || y < 0
        0
    else
        ic = Intcode(prog, [x, y])
        run(ic)
        ic.out[1]
    end
end

function read_data()
    progstr = strip(read("input.txt", String))
    [parse(Int, s) for s in split(progstr,",")]
end

function part_one()
    prog = read_data()

    println()
    s = 0
    for y in 0:49
        for x in 0:49
            c = check_coord(prog, x, y)
            s += c
            if c == 1
                print("#")
            else
                print(".")
            end
        end
        println()
    end
    println("PART ONE: ", s)
end

function find_xmin(prog::Vector{Int}, y::Int, xstart::Int, maxmove::Int)::Int
    for x in xstart:(xstart+maxmove)
        if check_coord(prog, x, y) == 1
            return x
        end
    end
    -1
end

function part_two()
    prog = read_data()
    y = 0
    x = 0
    found = false
    while true
        y += 1
        new_xmin = find_xmin(prog, y, x, 10)
        if new_xmin < 0
            continue
        end
        x = new_xmin
        if check_coord(prog, x+99, y-99) == 1 &&
           check_coord(prog, x, y-99) == 1 &&
           check_coord(prog, x+99, y) == 1
           # check all boxes?
           found = true
           break
       end
    end
    if found
        println(x, " ", y-99)
        println("PART TWO: ", x * 10000 + y - 99)
    else
        error("not found")
    end
end

part_one()
part_two()

