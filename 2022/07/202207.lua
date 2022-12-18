package.path = "../lua/?.lua;" .. package.path
local ml = require("mikelib")
local split = ml.String.split
local unpack = unpack or table.unpack

local function parse_cmd(cmd_str)
    local lines = split(cmd_str, "\n")
    print(cmd_str, lines)
    local cmd = split(lines[1], " ")
    if cmd[1] == "ls" then
      local args = lines:sub(2):map(split)
      cmd[2] = args
    end
    return cmd
end

local function parse(input)
  local cmd_strs = split(input, "$ "):sub(2)
  return cmd_strs:map(parse_cmd)
end

local tinput = parse(io.input("tinput.txt"):read("*a"))

print(tinput)

function process_command(line, tree, path)
  local cmd = line[2]
  if cmd == "cd" then
    local dir = line[2]
    if dir == ".." then
      path[#path] = nil
    else
      path[#path + 1] = dir
    end
  elseif cmd == "ls" then
    for _,item in ipairs(line[3]) do
      process_item(item, tree, path)
    end
  end
end


-- generate file tree by processing each line in the input
function generate_tree(input)
  local tree = {}
  local path = {}
  for _, cmd in ipairs(input) do
    process_command(cmd, tree, path)
  end
  return tree
end
