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
    local nr, nc = #img + 2 * n, #(img[1]) + 2 * n
    local pimg = array2d.new(nr, nc, 0)
    array2d.move(pimg, n + 1, n + 1, img)
    return pimg
end

local function enhance(alg, img, n_rounds)
    local nr, nc = array2d.size(img)
    for round = 1, n_rounds do
        -- print("ROUND", round)
        --print(array2d.write(img))
        local default_val = (alg[1] == 1 and round % 2 == 0) and 1 or 0
        local eimg = array2d.new(nr, nc, 0)
        for r = 1, nr do
            for c = 1, nc do
                local n = 0
                for ri = -1, 1 do
                    for ci = -1, 1 do
                        local rr = r + ri
                        local cc = c + ci
                        local p = default_val
                        if rr >= 1 and rr <= nr and cc >= 1 and cc <= nc then
                            p = img[rr][cc]
                        end
                        n = 2 * n + p
                    end
                end
                eimg[r][c] = alg[n + 1]
            end
        end
        img = eimg
    end
    return img
end

local function part1(alg, img)
    local img = pad(img, 4)
    local enhanced_img = enhance(alg, img, 2)
    return array2d.flatten(enhanced_img):reduce("+")
end

assert(part1(talg, timg) == 35, "part1")

local alg, img = read_data("input.txt")

print("PART1:", part1(alg, img))

local function part2(alg, img)
    local img = pad(img, 55)
    local enhanced_img = enhance(alg, img, 50)
    return array2d.flatten(enhanced_img):reduce("+")
end

assert(part2(talg, timg) == 3351, "part2")
print("PART2:", part2(alg, img))
