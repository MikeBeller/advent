inspect = require("inspect")

function parse(fpath)
    local data = {}
    local scanner = {}
    for line in io.lines(fpath) do
        if line:sub(1,3) == "---" then
            scanner = {}
            data[#data+1] = scanner
        elseif line == "" then
            -- pass
        else
            local xs,ys,zs = line:match("(-?%d+),(-?%d+),(-?%d+)")
            print( line:gmatch("(-?%d+),(-?%d+),(-?%d+)"))
            scanner[#scanner+1] = {tonumber(xs), tonumber(ys), tonumber(zs)}
        end
    end
    return data
end

function point_lt(p1, p2)
    return p1[1] < p2[1] and p1[2] < p2[2] and p1[3] < p2[3]
end

function diff(p1, p2)
    return p1[1] - p2[1], p1[2] - p2[2], p1[3] - p2[3]
end

function adjust_all(beacons, dx, dy, dz)
    local adjusted_beacons = {}
    for beacon in beacons do
        adjusted_beacons[#adjusted_beacons + 1] = {beacon[1] - dx, beacon[2] - dy, beacon[3] - dz}
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

function rotate_all(scanner, rotation)
    -- must return a copy of the beacons, rotated (don't mutate)
    rotated = {}
    for i,beacon in scanner do
        rotated[#rotated + 1] = rotate(beacon, rotation)
    end
    return rotated
end

function align(aligned_scanner, scanner, rotation)
    local rotated_scanner = rotate_all(scanner, rotation)
    table.sort(rotated_scanner, point_lt)
    for i = 1,#aligned_scanner-11 do
        local dx,dy,dz = diff(aligned_scanner[i], rotated_scanner[1])
        local count = 1
        for j = 2, #rotated_scanner do
            local dx2,dy2,dz2 = diff(aligned_scanner[i + j - 1], rotated_scanner[j])
            if dx == dx2 and dy == dy2 and dz == dz2 then
                count = count + 1
                if count >= 12 then
                    print("delta is", dx, dy, dz)
                    return true, adjust_all(rotated_scanner, dx, dy, dz)
                end
            end
        end
    end
    return false, nil
end

function align_scanner(aligned_scanners, scanner)
    for aligned_scanner in aligned_scanners do
        for rotation = 1,6 do
            local ok, newly_aligned_scanner = align(aligned_scanner, scanner, rotation)
            if ok then
                return ok, newly_aligned_scanner
            end
        end
    end
    return false, nil
end

function align_scanners(scanners)
    local aligned = {scanners[1]}
    local unaligned = {}
    for i = 2,#scanners do
        unaligned[#unaligned + 1] = scanners[i]
    end
    while #unaligned ~= 0 do
        print("num unaligned:", #unaligned)
        for i,scanner in ipairs(unaligned) do
            print("scanner:", i)
            local ok, newly_aligned_scanner = align_scanner(aligned, scanner)
            if ok then
                table.remove(unaligned, i)
                aligned[#aligned + 1] = newly_aligned_scanner
                break
            end
        end
    end
    return aligned
end

function num_unique_beacons(scanners)
    local count = 0
    local tab = {}
    for _,scanner in ipairs(scanners) do
        for _,beacon in ipairs(beacons) do
            local bs = table.concat(beacon, ",")
            if not tab[bs] then
                tab[bs] = true
                count = count + 1
            end
        end
    end
    return count
end

function part1(scanners)
    local aligned_scanners = align_scanners(scanners)
    return num_unique_beacons(aligned_scanners)
end

print(part1("tinput.txt"))