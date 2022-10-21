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

local function run_intcode(mem)
    local pc = 0
    local a, b, c = 0, 0, 0
    local aa, ba, ca = 0, 0, 0
    local unpack = unpack or table.unpack
    while true do
        local inst = mem[pc + 1] or 0
        if inst == 1 or inst == 2 then
            aa, ba, ca = unpack(mem, pc + 2, pc + 4)
            a = mem[aa + 1] or 0
            b = mem[ba + 1] or 0
            c = inst == 1 and a + b or a * b
            mem[ca + 1] = c
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
        mem[a] = v
    end
    return mem
end

local function part1(prog)
    local mem = load_mem(prog)
    mem[2] = 12
    mem[3] = 2
    run_intcode(mem)
    return mem[1]
end

assert(run_intcode(load_mem(tdata))[1] == 3500, "intcode")

local data = parse_data(io.open("input.txt"):read("*a"))
print("PART1:", part1(data))

function run_nv(prog, noun, verb)
    local mem = load_mem(prog)
    mem[2] = noun
    mem[3] = verb
    run_intcode(mem)
    return mem
end

function part2(prog)
    for noun = 0, 99 do
        for verb = 0, 99 do
            local mem = run_nv(prog, noun, verb)
            if mem[1] == 19690720 then
                return (mem[2] or 0) * 100 + (mem[3] or 0)
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
