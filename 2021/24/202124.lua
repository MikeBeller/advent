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

local function sgn(x)
    return (x < 0) and -1 or 1
end

local mtab = seq(seq.range(0, 13)):map(function(x) return 10 ^ x end):copy()
print(mtab)

local function run(prog, input)
    --print("START")
    local iind = 14
    local st = Map { w = 0, x = 0, y = 0, z = 0 }
    local tmp
    for inst in prog:iter() do
        -- print(st, inst)
        local cmd, op1, op2 = unpack(inst)
        if cmd == "inp" then
            local v = floor(input / mtab[iind]) % 10
            print(inst, st, v)
            if v == 0 then
                return false, st
            end
            iind = iind - 1
            st[op1] = v
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
    return true, st
end

local tinput = parse(io.input("tinput.txt"):read("*a"))
--assert(run(tinput, istream({ 11 })) == Map { w = 1, x = 0, y = 1, z = 1 })

local prog = parse(io.input("input.txt"):read("*a"))
--print(model_num("12345678912345"))
--assert(select(2, run(prog, 13579246899999)).z == 25910832)
print(run(prog, 11111111111111))
--print(run(prog, model_num("99999999999999")))

local function part1(prog)
    local prefix = 0
    local ok, st
    for d = 0, 13 do
        local mpy = 10 ^ (13 - d)
        local found = false
        for i = 1, 9 do
            local mn = (prefix * 10 + i) * mpy
            ok, st = run(prog, mn)
            if st.z == 0 then
                print("locked in:", i, st)
                prefix = 10 * prefix + i
                found = true
                break
            end
        end
        if not found then
            print("NOT FOUND", st)
            return false, st
        end
    end
    return prefix, st
end

part1(prog)
