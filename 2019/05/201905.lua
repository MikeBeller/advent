-- local ffi = require("ffi")

local yield = coroutine.yield
local resume = coroutine.resume
-- local instruction_counter = 0

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
        -- instruction_counter = instruction_counter + 1
        local inst = mem[pc]
        local op = inst % 100
        inst = floor(inst / 100)
        local am = inst % 10
        inst = floor(inst / 10)
        local bm = inst % 10
        -- inst = inst // 10
        -- local cm = inst
        if op == 1 or op == 2 then
            a = get(mem, pc + 1, am)
            b = get(mem, pc + 2, bm)
            c = op == 1 and a + b or a * b
            mem[mem[pc + 3]] = c -- must not be immediate
            pc = pc + 4
        elseif op == 3 then
            a = yield()
            mem[mem[pc + 1]] = a
            pc = pc + 2
        elseif op == 4 then
            a = get(mem, pc + 1, am)
            yield(a)
            pc = pc + 2
        elseif op == 5 or op == 6 then
            a = get(mem, pc + 1, am)
            b = get(mem, pc + 2, bm)
            if (op == 5 and a ~= 0) or (op == 6 and a == 0) then
                pc = b
            else
                pc = pc + 3
            end
        elseif op == 7 or op == 8 then
            a = get(mem, pc + 1, am)
            b = get(mem, pc + 2, bm)
            if ((op == 7 and a < b) or (op == 8 and a == b)) then
                mem[mem[pc + 3]] = 1
            else
                mem[mem[pc + 3]] = 0
            end
            pc = pc + 4
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

local function make_process(prog, ...)
    local mem = load_mem(prog)
    local proc = coroutine.wrap(run_intcode)
    proc(mem)
    return proc
end

local function part1(prog)
    local proc = make_process(prog)
    local result = proc(1)
    while result == 0 do
        result = proc()
    end
    return result
end

local function test1()
    assert(make_process({ 3, 0, 4, 0, 99 })(333) == 333)
end

test1()

local data = parse_data(io.open("input.txt"):read("*a"))
print("PART1:", part1(data))

local function part2(prog)
    -- instruction_counter = 0
    local proc = make_process(prog)
    local result = proc(5)
    -- print("INSTCOUNT", instruction_counter)
    return result
end

print("PART2:", part2(data))

-- local function bench(n)
--     for i = 1, n do
--         part2(data)
--     end
-- end

-- bench(100000)
