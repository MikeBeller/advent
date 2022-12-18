package.path = "../lua/?.lua;" .. package.path
local ml = require("mikelib")
local split = ml.String.split

local function parse_line(line)
    return split(line, " ")
end

local function parse(input)
  local lines = split(input, "\n")
  return lines:map(parse_line)
end

local tinput = parse(io.input("tinput.txt"):read("*a"))

print(tinput)

-- generate file tree by processing each line in the input
local function generate_tree(input)
  local tree = {}
  local path = {}
  for _, line in ipairs(input) do
    local parent = tree
    
  end
  return tree
end

