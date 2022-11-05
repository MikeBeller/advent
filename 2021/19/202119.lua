local inspect = require("inspect")
local abs = math.abs
local function pi(x) print(inspect(x)); return x end

local rotations = {
{-3, -2, -1},
{-3, -1, 2},
{-3, 1, -2},
{-3, 2, 1},
{-2, -3, 1},
{-2, -1, -3},
{-2, 1, 3},
{-2, 3, -1},
{-1, -3, -2},
{-1, -2, 3},
{-1, 2, -3},
{-1, 3, 2},
{1, -3, 2},
{1, -2, -3},
{1, 2, 3},
{1, 3, -2},
{2, -3, -1},
{2, -1, 3},
{2, 1, -3},
{2, 3, 1},
{3, -2, 1},
{3, -1, -2},
{3, 1, 2},
{3, 2, -1}
}

local function parse(fpath)
    local data = {}
    local num = 0
    for line in io.lines(fpath) do
        if line:sub(1,3) == "---" then
            local scanner = {num=num, beacons={}}
            data[#data+1] = scanner
        elseif line == "" then
            -- pass
        else
            local xs,ys,zs = line:match("(-?%d+),(-?%d+),(-?%d+)")
            local scanner = data[#data]
            scanner.beacons[#scanner.beacons+1] = {tonumber(xs), tonumber(ys), tonumber(zs)}
        end
    end
    return data
end

local function serialize(p)
    return string.format("%d,%d,%d", p[1], p[2], p[3])
end

local function diff(p1, p2)
    return p1[1] - p2[1], p1[2] - p2[2], p1[3] - p2[3]
end

local function adjust_all(beacons, dx, dy, dz)
    local adjusted_beacons = {}
    for i,beacon in ipairs(beacons) do
        adjusted_beacons[i] = {
            --beacon[1] - dx, beacon[2] - dy, beacon[3] - dz}
            beacon[1] + dx, beacon[2] + dy, beacon[3] + dz}
    end
    return adjusted_beacons
end

local function rotate(p, rotation)
    local rv = rotations[rotation]
    local rp = {0, 0, 0}
    for i = 1,3 do
        rp[i] = p[abs(rv[i])]
        if rv[i] < 0 then
            rp[i] = -rp[i]
        end
    end
    return rp
end

local function rotate_all(beacons, rotation)
    -- must return a copy of the beacons, rotated (don't mutate)
    local rotated = {}
    for i,beacon in ipairs(beacons) do
        rotated[i] = rotate(beacon, rotation)
    end
    return rotated
end

local function count_intersection(xs, ys)
    local tb = {}
    local count = 0
    for _,x in ipairs(xs) do
        tb[serialize(x)] = true
    end
    for _,y in ipairs(ys) do
        if tb[serialize(y)] then
            count = count + 1
        end
    end
    return count
end

local function align(aligned_beacons, rotated_beacons)
    for ai = 1,#aligned_beacons do
        for bi = 1,#rotated_beacons do
            local dx,dy,dz = diff(aligned_beacons[ai], rotated_beacons[bi])
            local adjusted_beacons = adjust_all(rotated_beacons, dx, dy, dz)
            local count = count_intersection(aligned_beacons, adjusted_beacons)
            if count >= 12 then
                print("found offset:", serialize({dx,dy,dz}))
                return true, adjusted_beacons, dx, dy, dz
            end
        end
    end
    return false, nil
end


local function align_scanners(scanners)
    local aligned_scanners = {scanners[1]}
    scanners[1].adjusted_beacons = scanners[1].beacons
    local unaligned_scanners = {unpack(scanners,2)}
    while #unaligned_scanners ~= 0 do
        print("num unaligned:", #unaligned_scanners)
        local old_num_unaligned = #unaligned_scanners
        for ui = 1,#unaligned_scanners do
            local aligned = false
            for rotation = 1,#rotations do
                -- print("rotation is", rotation)
                local rotated_beacons = rotate_all(unaligned_scanners[ui].beacons, rotation)
                for ai = 1,#aligned_scanners do
                    local reference_scanner = aligned_scanners[ai]
                    local ok, adjusted_beacons = align(
                        reference_scanner.beacons, rotated_beacons)
                    if ok then
                        local scanner = table.remove(unaligned_scanners, ui)
                        scanner.adjusted_beacons = adjusted_beacons
                        aligned_scanners[#aligned_scanners + 1] = scanner
                        aligned = true
                        break
                    end
                end
                if aligned then break end
            end
            if aligned then break end
        end
        if #unaligned_scanners == old_num_unaligned then
            error(string.format("num_unaligned remained %d for 2 iterations",
                #unaligned_scanners))
        end
    end
    return aligned_scanners
end

local function count_unique_beacons(scanners)
    local count = 0
    local tb = {}
    for _,scanner in ipairs(scanners) do
        for _,beacon in ipairs(scanner.adjusted_beacons) do
            local bs = serialize(beacon)
            if not tb[bs] then
                tb[bs] = true
                count = count + 1
                print(bs)
            end
        end
    end
    return count
end

local function part1(scanners)
    local aligned_scanners = align_scanners(scanners)
    return count_unique_beacons(aligned_scanners)
end

local tdata = parse("tinput.txt")

assert(#tdata == 5, "parse")

local function test1(ss)
    local rp = pi(rotate({5, 6, 7}, 8))
    assert(rp[1] == -6 and rp[2] == 7 and rp[3] == -5, "test1")
end

test1()

local function test2(ss)
    for rotation = 1,#rotations do
        print(rotation)
        local rotated_beacons = rotate_all(ss[2].beacons, rotation)
        local ok, ascan = align(ss[1].beacons, rotated_beacons)
        if ok then return end
    end
    error("align test failed")
end

test2(tdata)

--print(part1(tdata))

-- local data = parse("input.txt")
-- local ans = part1(data)
-- print("PART1:", ans)
