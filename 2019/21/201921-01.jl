
include("intcode.jl")

function run_springscript(prog, script::String)::Vector{Int}
    inp = [Int(c) for c in script]
    ic = Intcode(prog, inp)
    run(ic)
    ic.out
end

function read_data()
    progstr = strip(read("input.txt", String))
    [parse(Int, s) for s in split(progstr,",")]
end

function run_print(prog::Vector{Int}, sc::String)
    out = run_springscript(prog, sc)
    if out[end] > 127
        println(string(out[end]))
    else
        print(string([Char(c) for c in out]...))
    end
end

prog = read_data()
#run_print(prog, "NOT D J\nWALK\n")
print("PART 1: ")
run_print(prog, "NOT A J\nNOT B T\nOR T J\nNOT C T\nOR T J\nAND D J\nWALK\n")

function run_for_result(prog::Vector{Int}, sc::String)::Int
    out = run_springscript(prog, sc)
    if out[end] > 127
        out[end]
    else
        -1
    end
end

@assert run_for_result(prog, "NOT A J\nNOT B T\nOR T J\nNOT C T\nOR T J\nAND D J\nWALK\n") == 19360724
@assert run_for_result(prog, "NOT D J\nWALK\n") == -1

function gen_springscript(n::Int, numl::Int, cmd::String)::String
    insts = []
    letters = "ABCDEFGHI"
    for i in 1:numl
        letter = letters[i]
        b = n & 1
        n = n >> 1
        if i == 1
            push!(insts, "NOT A J")
            if b == 1
                push!(insts, "NOT J J")
            end
        else
            if b == 0
                push!(insts, "NOT $letter T")
                push!(insts, "AND T J")
            else
                push!(insts, "AND $letter J")
            end
        end
    end
    push!(insts, cmd)
    push!(insts, "")
    join(insts, "\n")
end

function part_two()
    prog = read_data()
    res = -1
    #for i in 0:(2^9-1)
    for i in 0:(2^4-1)
        sc = gen_springscript(i, 4, "WALK")
        print(sc)
        res = run_for_result(prog, sc)
        if res != -1
            break
        end
    end
    res
end

r = part_two()
println("PART 2: ", r)

