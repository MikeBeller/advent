local inspect = require("inspect")

local function read_data(fpath)
    local instr = io.open(fpath):read("*a")
    local alg_s, img_s = string.match(instr, "(%S+)\n\n(.+)$")
    local alg = {}
    for i = 1, #alg_s do
        alg[i - 1] = (string.byte(alg_s, i) == 35) and 1 or 0
    end
    local img = {}
    local r, c = 0, 0
    img[r] = {}
    local n = 1
    print("LEN", #img_s, img_s)
    while n <= #img_s do
        local ch = string.byte(img_s, n)
        --print(n, ch)
        if ch == 35 or ch == 46 then
            img[r][c] = (ch == 35) and 1 or 0
            c = c + 1
        elseif ch == 10 then
            r = r + 1
            img[r] = {}
            c = 0
        end
        n = n + 1
    end
    return alg, img
end

local alg, img = read_data("tinput.txt")
print("ALG", inspect(alg))
print("IMG", inspect(img))
