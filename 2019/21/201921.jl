
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
# (!A | !B | !C) & D & (H | E)
run_print(prog, "NOT A J\nNOT B T\nOR T J\nNOT C T\nOR T J\nAND D J\nWALK\n")

print("PART 2: ")
# (!A | !B | !C) & D & (H | E)
run_print(prog, "NOT A T\nNOT T T\nAND B T\nAND C T\nNOT T J\nAND D J\nNOT H T\nNOT T T\nOR E T\nAND T J\nRUN\n")

