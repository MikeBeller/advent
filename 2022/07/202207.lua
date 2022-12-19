package.path = "../lua/?.lua;" .. package.path
local ml = require("mikelib")
local split = ml.String.split
local List, Map = ml.List, ml.Map
local unpack = unpack or table.unpack

local function parse_cmd(cmd_str)
    local lines = split(cmd_str, "\n")
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

local orig_tree

-- generate file tree by processing each line in the input
local function generate_tree(input)
  local tree = Map{}
  while #input > 0 do
    local cmd = input:pop()
    print(cmd)
    print("TREE", tree)
    if cmd[1] == "cd" then
      local dname = cmd[2]
      if dname == ".." then
        return tree
      elseif dname == "/" then
        -- ignore
      else
        assert(tree[dname], "Directory does not exist: " .. dname)
        return generate_tree(input)
      end
    elseif cmd[1] == "ls" then
      for _,item in ipairs(cmd[2]) do
        print("ITEM", item)
        if item[1] == "dir" then
          tree[item[2]] = Map{}
        else
          assert(tonumber(item[1]))
          tree[item[2]] = tonumber(item[1])
        end
      end
      print("TREE2", tree)
    end
  end
  return tree
end

local function part1(input)
  local data = input:reversed()
  local tree = generate_tree(data)
  return tree
end

print(part1(tinput))
