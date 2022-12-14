package.path = "../lua/?.lua;" .. package.path
local ml = require('mikelib')
local String, List = ml.String, ml.List
local unpack = table.unpack or unpack

function parse_stacks(stack_str)
    local stacks = List{}
    local stack_lines = String.split(stack_str, "\n")
    local last_line = stack_lines:pop()
    local n_stacks = #(last_line:gsub("%s+", ""))
    for li = #stack_lines, 1, -1 do
        local line = stack_lines[li]
        for i = 1, n_stacks do
            local ci = (i-1) * 4 + 2
            if ci > #line then
                break
            end
            local c = line:sub(ci, ci)
            if c ~= " " then
                stacks[i] = stacks[i] or List{}
                stacks[i]:append(c)
            end
        end
    end

    return stacks
end

function parse_moves(move_str)
    local moves = List{}
    for _,line in ipairs(String.split(move_str, "\n")) do
        local num, from, to = line:match("move (%d+) from (%d+) to (%d+)")
        moves:append(List{tonumber(num), tonumber(from), tonumber(to)})
    end
    return moves
end

function parse(instr)
    local stack_str, move_str = unpack(String.split(instr, "\n\n"))
    return parse_stacks(stack_str), parse_moves(move_str)
end

local tinput_str = io.input("tinput.txt"):read("*a")
local tstacks, tmoves = parse(tinput_str)

function part1(stacks, moves)
    local stacks = stacks:map(function (st) return st:copy() end)
    for _, move in ipairs(moves) do
        local num, from, to = unpack(move)
        local from_stack = stacks[from]
        local to_stack = stacks[to]
        for i = 1, num do
            local from_top = from_stack:pop()
            to_stack:append(from_top)
        end
    end
    return stacks:map(function (st) return st[#st] end):join("")
end

assert(part1(tstacks, tmoves) == "CMZ")

local input_str = io.input("input.txt"):read("*a")
local stacks, moves = parse(input_str)
print(part1(stacks, moves))

function part2(stacks, moves)
    local stacks = stacks:map(function (st) return st:copy() end)
    for _, move in ipairs(moves) do
        local num, from, to = unpack(move)
        local from_stack = stacks[from]
        local to_stack = stacks[to]
        local fs = #from_stack
        local base = fs - num + 1
        for i = 1, num do
            local fi = base + i - 1
            to_stack:append(from_stack[fi])
            from_stack[fi] = nil
        end
    end
    return stacks:map(function (st) return st[#st] end):join("")
end

assert(part2(tstacks, tmoves) == "MCD")
print(part2(stacks, moves))