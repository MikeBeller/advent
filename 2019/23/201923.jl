
include("intcode.jl")

function read_data()
    progstr = strip(read("input.txt", String))
    [parse(Int, s) for s in split(progstr,",")]
end

function part_one()
    prog = read_data()
end

part_one()

