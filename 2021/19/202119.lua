local inspect = require("inspect")
local abs = math.abs
local function pi(x) print(inspect(x)); return x end

local function sgn(x)
    return (x < 0 and -1) or (x > 0 and 1) or 0
end

local rotation_codes = { {-3, -2, -1}, {-3, -1, 2}, {-3, 1, -2},
    {-3, 2, 1}, {-2, -3, 1}, {-2, -1, -3}, {-2, 1, 3},
    {-2, 3, -1}, {-1, -3, -2}, {-1, -2, 3}, {-1, 2, -3},
    {-1, 3, 2}, {1, -3, 2}, {1, -2, -3}, {1, 2, 3},
    {1, 3, -2}, {2, -3, -1}, {2, -1, 3}, {2, 1, -3},
    {2, 3, 1}, {3, -2, 1}, {3, -1, -2}, {3, 1, 2}, {3, 2, -1} }

local function parse_rotations(codes)
    local rotations = {}
    for _,code in ipairs(codes) do
        local a,b,c = unpack(code)
        local inds = {abs(a), abs(b), abs(c)}
        local sgns = {sgn(a), sgn(b), sgn(c)}
        rotations[#rotations+1] = {inds, sgns}
    end
    return rotations
end

local rotations = parse_rotations(rotation_codes)

local Scanner = function(n, beacons, delta)
    return {num=n, beacons=(beacons or {}), delta=(delta or nil)}
end

local function parse(fpath)
    local data = {}
    local num = 0
    for line in io.lines(fpath) do
        if line:sub(1,3) == "---" then
            local scanner = Scanner(num)
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
            beacon[1] + dx, beacon[2] + dy, beacon[3] + dz}
    end
    return adjusted_beacons
end

local function rotate(p, rotation)
    local inds,sgns = unpack(rotation)
    local i1,i2,i3 = unpack(inds)
    local s1,s2,s3 = unpack(sgns)
    local rp = {  p[i1] * s1, p[i2] * s2, p[i3] * s3}
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
    error("unimplemented")
    for ai = 1,#aligned_beacons do
        for bi = 1,#rotated_beacons do
            local dx,dy,dz = diff(aligned_beacons[ai], rotated_beacons[bi])
            local count = count_intersection(aligned_beacons, adjusted_beacons)
            if count >= 12 then
                print("found offset:", serialize({dx,dy,dz}))
            end
        end
    end
    return false
end


local function align_one(aligned_scanners, unaligned_scanners)
    for ui = 1,#unaligned_scanners do
        for ri = 1,#rotations do
            -- print("rotation is", rotation)
            local rotation = rotations[ri]
            local rotated_beacons = rotate_all(unaligned_scanners[ui].beacons, rotation)
            for ai = 1,#aligned_scanners do
                local reference_scanner = aligned_scanners[ai]
                local delta = align(reference_scanner.beacons, rotated_beacons)
                if delta then
                    local adjusted_beacons = {}
                    local dx,dy,dz = unpack(delta)
                    for b in rotated_beacons do
                        local new_beacon = {b[1] + dx, b[2] + dy, b[3] + dz}
                        adjusted_beacons[#adjusted_beacons + 1] = new_beacon
                    end
                    return Scanner(unaligned_scanners[ui].num,
                        adjusted_beacons, delta), ui
                end
            end
        end
    end
    return nil
end

local function align_scanners(scanners)
    local aligned_scanners = {scanners[1]}
    local unaligned_scanners = {unpack(scanners,2)}
    while #unaligned_scanners ~= 0 do
        print("num unaligned:", #unaligned_scanners)
        local ok, newly_aligned_scanner, ui = align_one(aligned_scanners, unaligned_scanners)
        if ok then
            table.remove(unaligned_scanners, ui)
            aligned_scanners[#aligned_scanners + 1] = newly_aligned_scanner
        else
            error("no alignment found")
        end
    end
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

local function test1()
    local rp = pi(rotate({5, 6, 7}, rotations[8]))
    assert(rp[1] == -6 and rp[2] == 7 and rp[3] == -5, "test1")
end

test1()

local function test2(ss)
    for ri = 1,#rotations do
        local rotated_beacons = rotate_all(ss[2].beacons, rotations[ri])
        local ok, ascan = align(ss[1].beacons, rotated_beacons)
        if ok then return end
    end
    error("align test failed")
end

test2(tdata)

print(part1(tdata))

-- local data = parse("input.txt")
-- local ans = part1(data)
-- print("PART1:", ans)
