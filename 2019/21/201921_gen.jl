
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
#print("PART 1: ")
#run_print(prog, "NOT A J\nNOT B T\nOR T J\nNOT C T\nOR T J\nAND D J\nWALK\n")

function run_for_result(prog::Vector{Int}, sc::String)::Int
    out = run_springscript(prog, sc)
    if out[end] > 127
        out[end]
    else
        -1
    end
end

#@assert run_for_result(prog, "NOT A J\nNOT B T\nOR T J\nNOT C T\nOR T J\nAND D J\nWALK\n") == 19360724
#@assert run_for_result(prog, "NOT D J\nWALK\n") == -1

# struct representing a boolean equation in 'nv' variables
# 'tab' indicates the 'table number' such that all possible
# 2^nv equations in nv variables are represented.
#
# For nv == 2:
#   0 0 -> 1
#   0 1 -> 1
#   1 0 -> 0
#   1 1 -> 1
#
#   would be expressed with the number 11 (sort of a little-endian
#   representation of the truth table number)
#
# So that equation is represented as Eqn(2,11)
#
struct Eqn
    nv::Int
    tab::Int
end

# Generate the springscript for a single sum of products term
# for Eqn eqn, using only the T register for writing.  Because
# of the limitations of a single register, and the springscript
# instruction set, this requires applying demorgan's theorem.
# -- First "OR" together all the variables which are supposed
# to be false. Then invert the result.  Then "AND" in all the
# variables which are supposed to be true.
#
# The term argument is encoded as a binary number, i.e
# for Eqn with number of variables equal to 4:
#
#   A & B & !C & D would be encoded as 1011 or 11 ( a little endian
#   encoding where A = bit 0 and B = bit 1 and C = bit 2 etc)
function gen_springscript_term(eqn::Eqn, term::Int)::Vector{String}
    insts = []
    or = []
    and = []
    letters = "ABCDEFGHI"
    for i in 1:eqn.nv
        b = term & 1
        if b == 1
            push!(and, string(letters[i]))
        else
            push!(or, string(letters[i]))
        end
        term = term >> 1
    end
    for (i,l) in enumerate(or)
        if i == 1
            push!(insts, "NOT $l T")
            push!(insts, "NOT T T")
        else
            push!(insts, "OR $l T")
        end
    end
    if length(or) > 0
        push!(insts, "NOT T T")
        for (i,l) in enumerate(and)
            push!(insts, "AND $l T")
        end
    else
        for (i,l) in enumerate(and)
            if i == 1
                push!(insts, "NOT $l T")
                push!(insts, "NOT T T")
            else
                push!(insts, "AND $l T")
            end
        end
    end
    insts
end

# Given an equation eqn, generate a springscript to evaluate it
# such that J is 1 at the end of the evaluation if eqn evaluates
# to True.  This is done by breaking each row of the table into
# a product term, and generating a spring script using only the T register
# to evaluate that term, then using the J register to 'sum' together
# the products (for 'sum of products').
function gen_springscript(eqn::Eqn)::Vector{String}
    insts = []
    for term in 1:(2^eqn.nv)
        ts = gen_springscript_term(eqn, term)
        append!(insts, ts)
        if term == 1
            push!(insts, "NOT T J")
            push!(insts, "NOT J J")
        else
            push!(insts, "OR T J")
        end
    end
    insts
end

function finalize_springscript(insts::Vector{String}, additional::Vector{String})::String
    insts = append!([], insts)  # don't modify argument
    append!(insts, additional)
    push!(insts, "")
    join(insts, "\n")
end

function try_all()
    prog = read_data()
    res = -1
    for i in 0:(2^3-1)
        eq = Eqn(3,i)
        insts = gen_springscript(eq)
        script = finalize_springscript(insts, ["AND D J", "WALK"])
        res = run_for_result(prog, script)
        if res != -1
            println("EQN: ", eq, " ANS: ", res)
        else
            println("NO: ", eq, " ", insts)
        end
    end
end

println(gen_springscript_term(Eqn(3, 1), 4))
try_all()

