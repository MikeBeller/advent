require 'pl'
stringx.import()
local unpack = table.unpack

local function parg(s)
    return tonumber(s) or s
end

local function parse_inst(line)
    local f = line:split(" ")
    if f[1] == "inp" then
        return f
    else
        return List({ f[1], parg(f[2]), parg(f[3]) })
    end
end

local function parse(instr)
    return List(instr:lines()):map(parse_inst)
end

local function resolve(st, op)
    return (type(op) == "number") and op or st[op]
end

local function run(insts, inp_iter)
    local st = { w = 0, x = 0, y = 0, z = 0 }
    for inst in insts:iter() do

        cmd, op1, op2 = unpack(inst)
        if cmd == "inp" then
            st[op1] = next(inp_iter)
        elseif cmd == "add" then
            st[op1] = st[op1] + resolve(st, op2)
        elseif cmd == "mul" then
            st[op1] = st[op1] * resolve(st, op2)
        elseif cmd == "div" then
            st[op1] = st[op1] / resolve(st, op2)
        elseif cmd == "mod" then
            st[op1] = st[op1] % resolve(st, op2)
        elseif cmd == "eql" then
            st[op1] = (st[op1] == resolve(st, op2)) and 1 or 0
        else
            error("invalid op", cmd)
        end
    end
    return st
end

local tinput = parse(io.input("tinput.txt"):read("*a"))
print(run(tinput, seq({ 7 })))
