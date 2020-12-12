
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


