package.path = "../lua/?.lua;" .. package.path
local ml = require('mikelib')
local String, List = ml.String, ml.List
local unpack = table.unpack or unpack

function parse_stacks(stack_str)
    local stacks = List{}
    local stack_lines = String.split(stack_str, "\n")
    local last_line = table.remove(stack_lines)
    local n_stacks = #(last_line:gsub("%s+", ""))
    for i = 1, n_stacks do
        stacks[i] = List{}
    end
    for _, line in ipairs(stack_lines) do
        for i = 1, n_stacks do
            local ci = (i-1) * 4 + 2
            if ci > #line then
                break
            end
            local c = line:sub(ci, ci)
            if c ~= " " then
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
    for _, move in ipairs(moves) do
        local num, from, to = unpack(move)
        local from_stack = stacks[from]
        local to_stack = stacks[to]
        for i = 1, num do
            local from_top = from_stack:pop()
            to_stack:append(from_top)
        end
    end
    print(stacks)
    return stacks:map(function (st) return st[#st] end):join("")
end

print(part1(tstacks, tmoves))

