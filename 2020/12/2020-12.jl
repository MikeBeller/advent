
read_data(inp) = [(s[1],parse(Int, s[2:end]))
                  for s in split(strip(inp), "\n")]

td_string = """
F10
N3
F7
R90
F11"""
td = read_data(td_string)
@assert all(n % 90 == 0 for (c,n) in td if c in ['R','L'])

dir = Dict('E' => 0, 'S' => 90, 'W' => 180, 'N' => 270)

turn(d0,dd) = (d0 = (d0 + dd) % 360; if d0 < 0
               d0 + 360
           else
               d0
           end)

function step(state, cmd)
    (c,n) = cmd
    (dr0, x0, y0) = state
    if c == 'R'
        (turn(dr0, n), x0, y0)
    elseif c == 'L'
        (turn(dr0, -n), x0, y0)
    else
        dr = if c == 'F' dr0 else dir[c] end
        (x,y) = if dr == 0
            (x0 + n, y0)
        elseif dr == 90
            (x0, y0 + n)
        elseif dr == 180
            (x0-n, y0)
        else
            (x0, y0-n)
        end
        (dr0, x, y)
    end
end

function part1(data)
    state = (0, 0, 0)
    for cmd in data
        state = step(state, cmd)
    end
    (dr, x, y) = state
    abs(x) + abs(y)
end

@assert part1(td) == 25
data = read_data(read("input.txt", String))
println("PART1: ", part1(data))

function turn2(xw, yw, th)
    if th < 0
        th += 360
    end

    if th == 0
        (xw, yw)
    elseif th == 90
        (-yw, xw)
    elseif th == 180
        (-xw, -yw)
    elseif th == 270
        (yw, -xw)
    else
        @assert false "invalid angle"
    end
end

function step2(state, cmd)
    (c,n) = cmd
    (xs, ys, xw, yw) = state
    if c == 'F'
        (xs + n * xw, ys + n * yw, xw, yw)
    elseif c == 'E'
        (xs, ys, xw + n, yw)
    elseif c == 'S'
        (xs, ys, xw, yw + n)
    elseif c == 'W'
        (xs, ys, xw - n, yw)
    elseif c == 'N'
        (xs, ys, xw, yw - n)
    elseif c == 'R'
        xw, yw = turn2(xw, yw, n)
        (xs, ys, xw, yw)
    elseif c == 'L'
        xw, yw = turn2(xw, yw, -n)
        (xs, ys, xw, yw)
    else
        @assert false "invalid command"
    end
end

function part2(data)
    state = (0, 0, 10, -1)
    for cmd in data
        state = step2(state, cmd)
        #println(state)
    end
    (xs, ys, xw, yw) = state
    abs(xs) + abs(ys)
end

@assert part2(td) == 286
println("PART2: ", part2(data))

