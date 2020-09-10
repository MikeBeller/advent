
include("intcode.jl")

function run_springscript(prog, script::String)::String
    inp = [Int(c) for c in script]
    ic = Intcode(prog, inp)
    run(ic)
    if ic.out[end] > 127
        string(ic.out[end]) * "\n"
    else
        string([Char(c) for c in ic.out]...)
    end
end

function read_data()
    progstr = strip(read("input.txt", String))
    [parse(Int, s) for s in split(progstr,",")]
end

function run(sc::String)
    prog = read_data()
    out = run_springscript(prog, sc)
    print(out)
end

#run("NOT D J\nWALK\n")
print("PART 1: ")
run("NOT A J\nNOT B T\nOR T J\nNOT C T\nOR T J\nAND D J\nWALK\n")


#run("NOT A J\nNOT B T\nOR T J\nNOT C T\nOR T J\nAND D J\nRUN\n")
