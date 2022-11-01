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

function rotate(p, rotation)
    error("unimplemented")
    if rotation == 1 then
        return {p[1], p[2], p[3]}
    elseif rotation == 2 then
        return {p[1], p[2], p[3]}
    elseif rotation == 3 then
        return {p[1], p[2], p[3]}
    elseif rotation == 4 then
        return {p[1], p[2], p[3]}
    elseif rotation == 5 then
        return {p[1], p[2], p[3]}
    elseif rotation == 6 then
        return {p[1], p[2], p[3]}
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
    for i,beacon in rotated_scanner do
        error("unimplemented")
    end
    return rotated_scanner
end

function align_scanner(aligned_scanners, scanner)
    for aligned_scanner in aligned_scanners do
        for rotation = 1,6 do
            local ok, al, off = align(aligned_scanner, scanner, rotation)
            if ok then return ok, al, off end
        end
    end
    return false, nil, nil
end

function align_scanners(scanners)
    local aligned = {scanners[1]}
    local unaligned = {}
    for i = 2,#scanners do
        unaligned[#unaligned + 1] = scanners[i]
    end
    while #unaligned ~= 0 do
        for i,scanner in ipairs(unaligned) do
            if align_scanner(aligned, scanner) then
                table.remove(unaligned, i)
                aligned[#aligned + 1] = scanner
                break
            end
        end
    end
    return aligned
end

function num_unique_beacons(scanners)
    local count = 0
    local tab = {}
    for scanner in scanners do
        for beacon in beacons do
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




print(inspect(parse("tinput.txt")))

