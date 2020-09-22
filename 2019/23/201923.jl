
include("intcode.jl")

function read_data()
    progstr = strip(read("input.txt", String))
    [parse(Int, s) for s in split(progstr,",")]
end

function part_one()
    prog = read_data()
    nics = Vector{Intcode}()
    for i in 0:49
        nic = Intcode(prog)
        @assert run_to_event(nic) == 3
        push!(nic.inp, i)  # give it its network address
        run_to_event(nic)
    end

    while true
        for (i,nic) in enumerate(nics)
            # NIC must always be in awaiting input
            @assert nic.awaiting_input

            # consume all waiting messages
            if length(nic.inp > 0)
                @assert length(nic.inp) >= 3
                @assert run_to_event(nic) == 3
                @assert run_to_event(nic) == 3
                @assert run_to_event(nic) == 3
            else
                push!(nic.inp, -1)
                run_to_event(nic)
            end
            while length(nic.out >= 3)
                d = popleft!(nic.out)
                @assert d >= 0 && d <= 49
                x = popleft!(nic.out)
                y = popleft!(nic.out)
                if d == 255
                    return y
                end
                push!(nics[d].inp, x)
                push!(nics[d].inp, y)
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
    push!(nic.inp, 49)
    println(step(nic), nic.inp, nic.out)
    while true
        println(step(nic), nic.inp, nic.out)
        if nic.state == 99
            break
        elseif nic.state == 3
            push!(nic.inp, -1)
        end
    end
end

test1()




