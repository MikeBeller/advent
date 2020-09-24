
include("intcode.jl")

function read_data()
    progstr = strip(read("input.txt", String))
    [parse(Int, s) for s in split(progstr,",")]
end

function run_to_read(nic)
    while step(nic) != 3
        if nic.state == 99
            error("unexpected intcode 99 termination")
        end
    end
end

function part_one()
    prog = read_data()
    nics = Vector{Intcode}()
    for i in 0:49
        nic = Intcode(prog)
        @assert run_to_event(nic) == 3
        push!(nic.inp, i)  # give it its network address
        run_to_event(nic)
        push!(nics, nic)
    end

    while true
        for (i,nic) in enumerate(nics)
            while length(nic.inp) > 0
                run_to_read(nic)
            end
            push!(nic.inp, -1)
            run_to_read(nic)

            while length(nic.out) >= 3
                println("$(i-1) sending to: $(nic.out[1]) x: $(nic.out[2]) y: $(nic.out[3])")
                d = popfirst!(nic.out)
                @assert d >= 0 && d <= 49 || d == 255
                x = popfirst!(nic.out)
                y = popfirst!(nic.out)
                if d == 255
                    return y
                end
                push!(nics[d+1].inp, x)
                push!(nics[d+1].inp, y)
            end
        end
    end
    -1
end

r = part_one()
println("PART1: $r")
#
function test1()
    prog = read_data()
    println("PROGSIZE $(length(prog))")
    nic = Intcode(prog)
    push!(nic.inp, 0)
    println(step(nic), nic.inp, nic.out)
    while true
        println("STATE: $(nic.state) $(nic.inp) $(nic.out)")
        if nic.state == 99
            break
        elseif nic.state == 3
            println("FEEDING")
            push!(nic.inp, -1)
        end
        run_to_read(nic)
    end
end

#test1()




