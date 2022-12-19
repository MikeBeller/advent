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
local input = parse(io.input("input.txt"):read("*a"))

local orig_tree

-- generate file tree by processing each line in the input
local function generate_tree(input, tree)
  local path = List{tree}
  while #input > 0 do
    local cmd = input:pop()
    if cmd[1] == "cd" then
      local dname = cmd[2]
      if dname == ".." then
        tree = path:pop()
      else
        assert(tree[dname], "Directory does not exist: " .. dname)
        path:append(tree)
        tree = tree[dname]
      end
    elseif cmd[1] == "ls" then
      for _,item in ipairs(cmd[2]) do
        if item[1] == "dir" then
          tree[item[2]] = Map{}
        else
          assert(tonumber(item[1]))
          tree[item[2]] = tonumber(item[1])
        end
      end
    end
  end
end

local function add_sizes(tree)
  local size = 0
  for k,v in pairs(tree) do
    if type(v) == "table" then
      size = size + add_sizes(v)
    else
      size = size + v
    end
  end
  tree.size = size
  return size
end

-- find all directories in the tree that have size at most 100000
local function find_dirs(tree, max_size)
  local dirs = List{}
  for k,v in pairs(tree) do
    if type(v) == "table" then
      if v.size <= max_size then
        dirs:append(List{k, v.size})
      end
      dirs:extend(find_dirs(v, max_size))
    end
  end
  return dirs
end 

local function part1(input)
  local data = input:reversed()
  local tree = Map{["/"]=Map{}}
  generate_tree(data, tree)
  add_sizes(tree)
  local dirs = find_dirs(tree, 100000)
  return dirs:map(function(d) return d[2] end):sum()
end

assert(part1(tinput) == 95437)
print(part1(input))
