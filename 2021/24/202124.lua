require 'pl'
require 'pl.strict'
stringx.import()
local copy = tablex.copy
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
--print(mtab)

local function run(prog, input)
    local dind = 1
    local st = Map { w = 0, x = 0, y = 0, z = 0 }
    local tmp
    for inst in prog:iter() do
        local cmd, op1, op2 = unpack(inst)
        if cmd == "inp" then
            if dind > #input then
                return st
            end
            local v = input[dind]
            --print(inst, st, v)
            assert(v ~= 0)
            st[op1] = v
            dind = dind + 1
        elseif cmd == "add" then
            st[op1] = st[op1] + resolve(st, op2)
        elseif cmd == "mul" then
            st[op1] = st[op1] * resolve(st, op2)
        elseif cmd == "div" then
            tmp = resolve(st, op2)
            if tmp == 0 then
                error("div by zero")
            end
            tmp = st[op1] / tmp
            st[op1] = floor(abs(tmp)) * sgn(tmp)
        elseif cmd == "mod" then
            tmp = resolve(st, op2)
            if st[op1] < 0 or tmp <= 0 then
                error("illegal mod instruction")
            end
            st[op1] = fmod(st[op1], resolve(st, op2))
        elseif cmd == "eql" then
            st[op1] = (st[op1] == resolve(st, op2)) and 1 or 0
        else
            error("invalid instruction", cmd)
        end
    end
    return st
end

local tinput = parse(io.input("tinput.txt"):read("*a"))
--assert(run(tinput, istream({ 11 })) == Map { w = 1, x = 0, y = 1, z = 1 })

local prog = parse(io.input("input.txt"):read("*a"))
--print(model_num("12345678912345"))
--assert(select(2, run(prog, 13579246899999)).z == 25910832)

local function copy_map(m)
    return Map({}):update(m:items())
end

local function part1(prog)
    local ok, st
    local inp = List()
    for d = 1,14 do
        inp:append(1)
        local results = List()
        for v = 1,9 do
            inp[d] = v
            st = Map(copy(run(prog,inp)))
            st.inp = List(inp)
            print(st)
            results:append(st)
        end
        results:sort(function (a,b) return a.x < b.x or a.z < b.z end)
        print("BEST:", results[1])
        inp = results[1].inp
    end
end

--print(run(prog, 34611111111642))
part1(prog)
