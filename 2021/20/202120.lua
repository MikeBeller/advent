
local function read_data(fpath)
    local instr = io.open(fpath):read("*a")
    local ms = string.match("([^\s])+\n\n([^\s])+", instr)
    print(inspect(ms))
end
