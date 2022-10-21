local function parse_data(ins)
    local r = {}
    for ns in string.gmatch(ins, "[^,]+") do
        r[#r + 1] = tonumber(ns)
    end
    return r
end

local function tcmp(a, b) return table.concat(a, ",") == table.concat(b, ",") end

local tdata = parse_data("1,9,10,3,2,3,11,0,99,30,40,50")
assert(tcmp(tdata, { 1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50 }))


local function get(mem, addr) return mem[addr + 1] or 0 end

local function set(mem, addr, val) mem[addr + 1] = val end

local function get_i(mem, addr) return get(mem, get(mem, addr)) end

local function set_i(mem, addr, val) set(mem, get(mem, addr), val) end

local function run_intcode(mem)
    local pc = 0
    local a, b, c = 0, 0, 0
    while true do
        local inst = rawget(mem, pc + 1) or 0
        if inst == 1 or inst == 2 then
            a = rawget(mem, (rawget(mem, pc + 2) or 0) + 1) or 0 -- get_i(mem, pc + 1)
            b = rawget(mem, (rawget(mem, pc + 3) or 0) + 1) or 0 -- get_i(mem, pc + 2)
            c = inst == 1 and a + b or a * b
            rawset(mem, (rawget(mem, pc + 4) or 0) + 1, c) -- set_i(mem, pc + 3, c)
            pc = pc + 4
        elseif inst == 99 then
            break
        else
            error("invalid instruction")
        end
    end
    return mem
end

local function load_mem(prog)
    local mem = {}
    for a, v in ipairs(prog) do
        set(mem, a - 1, v)
    end
    return mem
end

local function part1(prog)
    local mem = load_mem(prog)
    set(mem, 1, 12)
    set(mem, 2, 2)
    run_intcode(mem)
    return get(mem, 0)
end

assert(get(run_intcode(load_mem(tdata)), 0) == 3500, "intcode")
local data = parse_data(io.open("input.txt"):read("*a"))
print("PART1:", part1(data))

function run_nv(prog, noun, verb)
    local mem = load_mem(prog)
    set(mem, 1, noun)
    set(mem, 2, verb)
    run_intcode(mem)
    return mem
end

function part2(prog)
    for noun = 0, 99 do
        for verb = 0, 99 do
            local mem = run_nv(prog, noun, verb)
            if get(mem, 0) == 19690720 then
                return get(mem, 1) * 100 + get(mem, 2)
            end
        end
    end
    error("not found")
end

print("PART2:", part2(data))

local function bench(prog, n)
    local res = 0
    local tot = 0
    for i = 1, n do
        res = part2(prog)
        tot = tot + res
    end
    return res, tot
end

print(bench(data, 100))
