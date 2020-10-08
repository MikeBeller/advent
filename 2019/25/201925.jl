
include("intcode.jl")

function read_data()
    progstr = strip(read("input.txt", String))
    [parse(Int, s) for s in split(progstr,",")]
end

function run_to_read(ic, with_write=false)
    while step(ic) != 3
        if ic.state == 99
            error("unexpected intcode 99 termination")
        elseif with_write && ic.state == 4
            print(join([Char(c) for c in ic.out], ""))
            empty!(ic.out)
        end
    end
end

function part_one()
    prog = read_data()
    ic = Intcode(prog)
    while true
        run_to_read(ic, true)
        while length(ic.inp) > 0
            run_to_read(ic, true)
        end
        line = readline()
        append!(ic.inp, Int(c) for c in line)
        push!(ic.inp, 10)
    end
end

part_one()

