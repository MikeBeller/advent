package.path = "../lua/?.lua;" .. package.path
local ml = require("mikelib")
local split = ml.String.split

local function parse_line(line)
    return split(line, " ")
end

local function parse(input)
  local lines = ml.split(input, "\n")
  return lines:map(parse_line)
end

local tinput = parse(io.input("tinput.txt"):read("*a"))

print(tinput)
