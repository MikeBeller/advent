local stringx = require('pl.stringx')
local List = require('pl.List')
local unpack = unpack or table.unpack
local array2d = require('pl.array2d')

local function cvt(c)
    return c == "#" and 1 or 0
end

local function read_data(fpath)
    local instr = io.open(fpath):read("*a")
    local alg_s, img_s = unpack(stringx.split(instr, "\n\n"))
    local alg = List(alg_s):map(cvt)
    local lines = stringx.splitlines(img_s)
    local img = lines:map(function(line)
        return List(line):map(cvt)
    end)
    return alg, img
end

local talg, timg = read_data("tinput.txt")

local function pad(img, n)
end

local function enhance(alg, o_img, n_rounds)
    local img = pad(o_img, n_rounds + 1)
    for round = 1, n_rounds do
        local img2 = {}
        for r = 1, #img do
            img2[r] = {}
            local n = 0
            for c = 1, #img[1] do
                for ri = -1, 1 do
                    for ci = -1, 1 do
                        local rr = r + ri
                        local cc = c + ci
                        local default = (alg[1] == 1 and round % 2 == 1 and
                            ((rr < 1 or rr > #img) or (cc < 1 or cc > max_c)))
                            and 1 or 0
                    end
                end
                img2[r][c] = alg[n + 1]
            end
        end
    end
end

local function part1(alg, img)
    local enhanced_image = enhance(alg, img, 2)
    return array2d.flatten(enhanced_img):reduce("+")
end

print(part1(talg, timg))
