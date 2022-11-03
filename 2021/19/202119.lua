inspect = require("inspect")
local abs = math.abs

function parse(fpath)
    local data = {}
    local num = 0
    for line in io.lines(fpath) do
        if line:sub(1,3) == "---" then
            scanner = {num=num, beacons={}}
            data[#data+1] = scanner
        elseif line == "" then
            -- pass
        else
            local xs,ys,zs = line:match("(-?%d+),(-?%d+),(-?%d+)")
            scanner.beacons[#scanner.beacons+1] = {tonumber(xs), tonumber(ys), tonumber(zs)}
        end
    end
    return data
end

function serialize(p)
    return string.format("%d,%d,%d", p[1], p[2], p[3])
end

function diff(p1, p2)
    return p1[1] - p2[1], p1[2] - p2[2], p1[3] - p2[3]
end

function adjust_all(beacons, dx, dy, dz)
    local adjusted_beacons = {}
    for i,beacon in ipairs(beacons) do
        adjusted_beacons[i] = {
            --beacon[1] - dx, beacon[2] - dy, beacon[3] - dz}
            beacon[1] + dx, beacon[2] + dy, beacon[3] + dz}
    end
    return adjusted_beacons
end

function rotate(p, rotation)
    if rotation == 1 then
        return {p[1], p[2], p[3]}
    elseif rotation == 2 then
        return {-p[3], p[2], p[1]}
    elseif rotation == 3 then
        return {-p[1], p[2], -p[3]}
    elseif rotation == 4 then
        return {p[3], p[2], -p[1]}
    elseif rotation == 5 then
        return {-p[1], -p[2], p[3]}
    elseif rotation == 6 then
        return {p[3], -p[2], p[1]}
    end
end

function rotate_all(beacons, rotation)
    -- must return a copy of the beacons, rotated (don't mutate)
    rotated = {}
    for i,beacon in ipairs(beacons) do
        rotated[i] = rotate(beacon, rotation)
    end
    return rotated
end

function count_intersection(xs, ys)
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

function align(aligned_beacons, rotated_beacons)
    for i = 1,#aligned_beacons do
        local dx,dy,dz = diff(aligned_beacons[i], rotated_beacons[1])
        local adjusted_beacons = adjust_all(rotated_beacons, dx, dy, dz)
        local count = count_intersection(aligned_beacons, adjusted_beacons)
        if count >= 12 then
            print("found offset:", serialize({dx,dy,dz}))
            return true, adjusted_beacons, dx, dy, dz
        end
    end
    return false, nil
end


function align_scanners(scanners)
    local aligned_scanners = {scanners[1]}
    scanners[1].adjusted_beacons = scanners[1].beacons
    local unaligned_scanners = {unpack(scanners,2)}
    while #unaligned_scanners ~= 0 do
        print("num unaligned:", #unaligned_scanners)
        local old_num_unaligned = #unaligned_scanners
        for ui = 1,#unaligned_scanners do
            local aligned = false
            for rotation = 1,6 do
                print("rotation is", rotation)
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
    return aligned
end

function count_unique_beacons(scanners)
    local count = 0
    local tb = {}
    for _,scanner in ipairs(scanners) do
        for _,beacon in ipairs(beacons) do
            local bs = serialize(beacon)
            if not tb[bs] then
                tb[bs] = true
                count = count + 1
            end
        end
    end
    return count
end

function part1(scanners)
    local aligned_scanners = align_scanners(scanners)
    return count_unique_beacons(aligned_scanners)
end

local tdata = parse("tinput.txt")

assert(#tdata == 5, "parse")

function test1(ss)
    local ok, ascan = align(ss[1], ss[2], 3)
end

function test2(ss)
    for rotation = 1,6 do
        local rotated_beacons = rotate_all(ss[2].beacons, rotation)
        local ok, ascan = align(ss[1], ss[2], rotated_beacons)
        return
    end
    error("align test failed")
end

test2(tdata)

print(part1(tdata))
