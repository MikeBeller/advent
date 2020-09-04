
include("intcode.jl")

function check_coord(prog, x::Int, y::Int)
    ic = Intcode(prog, [x, y])
    run(ic)
    ic.out[1]
end

function part_one()
    progstr = strip(read("input.txt", String))
    print(progstr)
    prog = [parse(Int, s) for s in split(progstr,",")]

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

part_one()

