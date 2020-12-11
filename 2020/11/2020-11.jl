
td_string = """
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL"""

read_data(inp) = reduce(vcat, permutedims.(collect.(split(strip(inp), "\n"))))

function nadj(m, sx, sy)
    h,w = size(m)
    c = 0
    for dy = -1:1
        y = sy + dy
        if y >= 1 && y <= h
            for dx = -1:1
                if dy == 0 && dx == 0 continue end
                x = sx + dx
                if x >=1 && x <= w
                    if m[y, x] == '#'
                        c += 1
                    end
                end
            end
        end
    end
    c
end

t1 = read_data("""
               .#.
               ###
               #.#""")
@assert nadj(t1, 2, 2) == 5
@assert nadj(t1, 1, 1) == 3

function life_step(m, seatcount, mxocc)
    h,w = size(m)
    nc = 0
    m2 = copy(m)
    for y = 1:h
        for x = 1:w
            c = m[y, x]
            if c == '.' continue end
            occ = seatcount(m, x, y)
            if c == 'L' && occ == 0
                m2[y, x] = '#'
                nc += 1
            elseif c == '#' && occ >= mxocc 
                m2[y, x] = 'L'
                nc += 1
            end
        end
    end
    m2, nc
end

function part1(m)
    nc = 1
    while nc != 0
        m,nc = life_step(m, nadj, 4)
    end
    count(c->c=='#', m)
end

function firstseat(m, sx, sy)
    h,w = size(m)
    nc = 0
    for dy = -1:1
        for dx = -1:1
            if dy == 0 && dx == 0 continue end
            x,y = (sx + dx, sy + dy)
            while x >= 1 && x <= w && y >= 1 && y <= h
                c = m[y, x]
                if c == '#' || c == 'L'
                    nc += if c == '#' 1 else 0 end
                    break
                end
                x,y = (x + dx, y + dy)
            end
        end
    end
    nc
end

t2 = """
.##.##.
#.#.#.#
##...##
...L...
##...##
#.#.#.#
.##.##."""

td2 = read_data(t2)
@assert firstseat(td2, 4, 4) == 0

function part2(m)
    nc = 1
    while nc != 0
        m,nc = life_step(m, firstseat, 5)
    end
    count(c->c=='#', m)
end

td = read_data(td_string)
@assert part1(td) == 37
data = read_data(read("input.txt", String))
println("PART1: ", part1(data))

@assert part2(td) == 26
println("PART2: ", part2(data))


