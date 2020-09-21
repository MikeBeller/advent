
mutable struct Intcode
    mem::Dict{Int,Int}
    inp::Vector{Int}
    out::Vector{Int}
    pc::Int
    relative_base::Int
    awaiting_input::Bool
end

Intcode(prog::Vector{Int}, input::Vector{Int}) = 
    Intcode( Dict(((i-1)=>v) for (i,v) in enumerate(prog)), input, [], 0, 0, false)
Intcode(prog::Vector{Int}) = Intcode(prog, Vector{Int}())

get_mem(ic::Intcode, addr::Int) = get(ic.mem, addr, 0)
set_mem(ic::Intcode, addr::Int, val::Int) = ic.mem[addr] = val

function get_parameter(ic::Intcode, offset::Int, mode::Int)
    p = get_mem(ic, ic.pc + offset)
    if mode == 1
        p
    elseif mode == 0
        get_mem(ic, p)
    else
        get_mem(ic, p + ic.relative_base)
    end
end

function set_parameter(ic::Intcode, offset::Int, mode::Int, val::Int)
    p = get_mem(ic, ic.pc + offset)
    if mode == 0
        set_mem(ic, p, val)
    else
        set_mem(ic, ic.relative_base + p, val)
    end
end

function run(ic::Intcode)
    while step(ic) != 99
    end
end

function run_to_event(ic::Intcode)
    r = step(ic)
    while r != 3 && r != 4 && r != 99
        r = step(ic)
    end
    r
end

# Execute one instruction and return the opcode.
# For case of input, return 3 for "about to read input" and
# return -3 for "just finished reading input"
function step(ic::Intcode)
    o = get_mem(ic, ic.pc)
    if o == 99
        return 99
    end

    op = o % 100
    (m0,m1,m2) = [div(o, i) % 10 for i in [100, 1000, 10000]]

    if op == 1 || op == 2
        a = get_parameter(ic, 1, m0)
        b = get_parameter(ic, 2, m1)
        set_parameter(ic, 3, m2, (op == 1 ? a + b : a * b))
        ic.pc += 4
    elseif op == 3
        if !ic.awaiting_input
            ic.awaiting_input = true
        else
            ic.awaiting_input = false
            n = popfirst!(ic.inp)
            set_parameter(ic, 1, m0, n)
            ic.pc += 2
        end
    elseif op == 4
        a = get_parameter(ic, 1, m0)
        push!(ic.out, a)
        ic.pc += 2
    elseif op == 5 || op == 6
        a = get_parameter(ic, 1, m0)
        b = get_parameter(ic, 2, m1)
        if (op == 5 && a != 0) || (op == 6 && a == 0)
            ic.pc = b
        else
            ic.pc += 3
        end
    elseif op == 7 || op == 8
        a = get_parameter(ic, 1, m0)
        b = get_parameter(ic, 2, m1)
        if (op == 7 && a < b) || (op == 8 && a == b)
            set_parameter(ic, 3, m2, 1)
        else
            set_parameter(ic, 3, m2, 0)
        end
        ic.pc += 4
    elseif op == 9
        a = get_parameter(ic, 1, m0)
        ic.relative_base += a
        ic.pc += 2
    else
        error("Invalid opcode: ", op)
    end

    (op == 3 && !ic.awaiting_input) ? -3 : op
end

function intcode_test(prgstr::String, inp::Vector{Int}=Vector{Int}())
    prog = [parse(Int, s) for s in split(prgstr, ",")]
    ic = Intcode(prog, inp)
    run(ic)
    ic.out
end

function intcode_tests()
    @assert intcode_test("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", [0]) == [0]
    @assert intcode_test("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", [1]) == [1]
    @assert intcode_test("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", [5]) == [999]
    @assert intcode_test("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", [8]) == [1000]
    @assert intcode_test("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", [9]) == [1001]

    # day 9 tests
    @assert intcode_test("1102,34915192,34915192,7,4,7,99,0") == [1219070632396864]
    @assert intcode_test("104,1125899906842624,99") == [1125899906842624]
    @assert intcode_test("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99") == [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
    println("All intcode tests passed")
end

intcode_tests()

