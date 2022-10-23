-- local ffi = require("ffi")

local yield = coroutine.yield
local resume = coroutine.resume

local function parse_data(ins)
    local r = {}
    for ns in string.gmatch(ins, "[^,]+") do
        r[#r + 1] = tonumber(ns)
    end
    return r
end

local function get(mem, addr, mode)
    local v = mem[addr]
    -- return mode == 1 and v or mem[v]
    if mode == 1 then
        return v
    else
        return mem[v]
    end
end

local function run_intcode(mem)
    local floor = math.floor
    local pc = 0
    local a, b, c = 0, 0, 0
    while true do
        local inst = mem[pc]
        local op = inst % 100
        inst = floor(inst / 100)
        local am = inst % 10
        inst = floor(inst / 10)
        local bm = inst % 10
        -- inst = inst // 10
        -- local cm = inst
        print(op, am, bm)
        if op == 1 or op == 2 then
            a = get(mem, pc + 1, am)
            b = get(mem, pc + 2, bm)
            c = op == 1 and a + b or a * b
            mem[mem[pc + 3]] = c -- must not be immediate
            pc = pc + 4
        elseif op == 3 then
            a = yield()
            print("got here", a)
            mem[mem[pc + 1]] = a
            pc = pc + 2
        elseif op == 4 then
            a = get(mem, pc + 1, am)
            print("writing", a)
            yield(a)
            pc = pc + 2
        elseif op == 99 then
            break
        else
            error("invalid instruction")
        end
    end
    return mem
end

local function load_mem(prog)
    -- local mem = ffi.new("int[256]")
    local mem = {}
    for i = 0, #prog - 1 do -- faster than ipairs!!
        mem[i] = prog[i + 1]
    end
    return mem
end

local function run_as_coroutine(prog, ...)
    local mem = load_mem(prog)
    local comp = coroutine.create(run_intcode)
    local res = resume(comp, ...)
    local res, out = resume(comp)
    return out
end

local function part1(prog)
    return run_as_coroutine(prog, 1)
end

local function test1()
    print(run_as_coroutine({ 3, 0, 4, 0, 99 }), 333)
end

test1()

local data = parse_data(io.open("input.txt"):read("*a"))
print("PART1:", part1(data))
