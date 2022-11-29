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

local function run(prog, input, start_digit, start_z)
    local start_digit = start_digit or 1
    local start_z = start_z or 0
    local dind = 1
    assert(18 == #prog / 14)
    local iind = (start_digit - 1) * 18 + 1
    local st = Map { w = 0, x = 0, y = 0, z = start_z }
    local tmp
    for ii = iind, iind + (#input*18) - 1 do
        if prog[ii] == nil then
            print(ii, #prog, prog[ii], iind, #input)
            error("wtf")
        end
        local cmd, op1, op2 = unpack(prog[ii])
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


function gen_digits(nd)
    local digits = seq.copy(seq.range(1,nd)):map(function (x) return 1 end)
    digits[nd] = 0
    return function()
        local di = nd
        while digits[di] == 9 do
            digits[di] = 1
            di = di - 1
            if di == 0 then
                return nil
            end
        end
        digits[di] = digits[di] + 1
        return digits
    end
end

local function digits_to_num(digits)
    return digits:reduce(function (acc, d) return acc * 10 + d end)
end

-- return a map of all input,output.z pairs for a set of digits of the machine
function run_group(prog, start_digit, num_digits, start_z)
    local r = List()
    for digits in gen_digits(num_digits) do
        local st = run(prog, digits, start_digit, start_z)
        r:append(List{digits_to_num(digits), st.z})
    end
    return r:sorted(function (a,b) return a[2] < b[2] end)
end

print(run_group(prog, 1, 4, 0):slice(1,10))
--part1(prog)

function part1(prog)
    local g1 = run_group(prog, 1, 5, 0)
    local zs = seq(g1:map(function (st) return st[2] end)):unique():copy()
    -- for i2 = 1,10 do
    --      local g2 = run_group(prog, 6, 6, zs[i2])
    --      print(g1[i2], g2:slice(1,5))
    -- end
    local Z3 = MultiMap()
    for z3 = 1,100 do
        local g3 = run_group(prog, 12, 3, z3)
        if g3[1][2] == 0 then
            g3:filter(function (item) return item[2] == 0 end):foreach(function (item) Z3:set(z3,item[1]) end)
        end
    end
    print(Z3)

    local Z2 = MultiMap()
    for k,v in pairs(Z3) do
        for z2 = 1,100 do
            local g2 = run_group(prog, 6, 6, z2)
            print(g2:slice(1,10))
        end
    end
end

part1(prog)