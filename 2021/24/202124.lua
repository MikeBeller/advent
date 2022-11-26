require 'pl'
require 'pl.strict'
stringx.import()
local unpack = table.unpack
local floor, fmod, abs = math.floor, math.fmod, math.abs

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

local function istream(ls)
    return coroutine.wrap(function()
        for _, v in ipairs(ls) do
            coroutine.yield(v)
        end
    end)
end

local function model_num(mns)
    return istream(
        seq(List.iterate(mns)):map(tonumber):copy()
    )
end

local function sgn(x)
    return (x < 0) and -1 or 1
end

local function run(insts, inp_stream)
    local st = Map { w = 0, x = 0, y = 0, z = 0 }
    local tmp, atmp
    for inst in insts:iter() do
        -- print(st, inst)
        local cmd, op1, op2 = unpack(inst)
        if cmd == "inp" then
            st[op1] = inp_stream()
        elseif cmd == "add" then
            st[op1] = st[op1] + resolve(st, op2)
        elseif cmd == "mul" then
            st[op1] = st[op1] * resolve(st, op2)
        elseif cmd == "div" then
            tmp = st[op1] / resolve(st, op2)
            st[op1] = floor(abs(tmp)) * sgn(tmp)
        elseif cmd == "mod" then
            st[op1] = fmod(st[op1], resolve(st, op2))
        elseif cmd == "eql" then
            st[op1] = (st[op1] == resolve(st, op2)) and 1 or 0
        else
            error("invalid op", cmd)
        end
    end
    return st
end

local tinput = parse(io.input("tinput.txt"):read("*a"))
assert(run(tinput, istream({ 11 })) == Map { w = 1, x = 0, y = 1, z = 1 })

local input = parse(io.input("input.txt"):read("*a"))
--print(run(input, model_num("13579246899999")))
--print(run(input, model_num("13579246900000")))
--print(run(input, model_num("99999999999999")))

local function part1(input)
    for i = 1111111, 9999999 do
        local si = tostring(i)
        if not si:find('0') then
            --local mn = "999999999" .. si
            local mn = si .. "999999999"
            local st = run(input, model_num(mn))
            if st.z == 0 then
                print("FOUND", mn)
            end
        end
    end
end

print(part1(input))
