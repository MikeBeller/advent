
test_data = """
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6"""

struct Inst
    op::String
    arg::Int
end

read_data(inp) = [Inst(s,parse(Int,i))
                for (s,i) in
                (split(f) for f in split(strip(inp),"\n"))]

struct Console
    acc::Int
    ip::Int
end

function step(c::Console, inst::Inst)::Console
    if inst.op == "acc"
        Console(c.acc + inst.arg, c.ip + 1)
    elseif inst.op == "nop"
        Console(c.acc, c.ip + 1)
    elseif inst.op == "jmp"
        Console(c.acc, c.ip + inst.arg)
    else
        @assert false "invalid op: " + repr(inst)
    end
end

function run_to_done_or_loop(prog)
    done = similar(prog, Bool)
    c = Console(0, 1)
    while c.ip <= length(prog) && !done[c.ip]
        done[c.ip] = true
        c = step(c, prog[c.ip])
    end
    c
end

function part1(prog)
    run_to_done_or_loop(prog).acc
end

testprog = read_data(test_data)
@assert part1(testprog) == 5

prog = read_data(read("input.txt", String))
println("PART1: ", part1(prog))

function part2(prog)
    ln = length(prog)
    for i = 1:ln
        if prog[i].op == "jmp"
            prog[i] = Inst("nop", prog[i].arg)
            c = run_to_done_or_loop(prog)
            if c.ip == ln + 1
                return c.acc
            end
            prog[i] = Inst("jmp", prog[i].arg)
        elseif prog[i].op == "nop"
            prog[i] = Inst("jmp", prog[i].arg)
            c = run_to_done_or_loop(prog)
            if c.ip == ln + 1
                return c.acc
            end
            prog[i] = Inst("nop", prog[i].arg)
        end
    end
    @assert false "wtf?"
end

@assert part2(testprog) == 8

println("PART2: ", part2(prog))


