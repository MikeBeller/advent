
const MASK = 1
const SET = 2

function read_mask(s)
    @assert length(s) == 36
    m = 0
    v = 0
    for i = 1:36
        m *= 2
        m += if s[i] == 'X' 1 else 0 end
        v *= 2
        v += if s[i] == '1' 1 else 0 end
    end
    (m, v)
end

function read_data(inp)
    r = []
    for line in split(strip(inp), "\n")
        f = split(line, " ")
        if f[1] == "mask"
            m,v = read_mask(f[3])
            push!(r, (MASK, m, v))
        else
            sbr = findfirst('[', f[1])
            ebr = findfirst(']', f[1])
            addr = parse(Int, f[1][sbr+1:ebr-1])
            val = parse(Int,f[3])
            push!(r, (SET, addr, val))
        end
    end
    r
end

tds = """
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0"""

td = read_data(tds)

apply((m, v), x) = (x & m) | (v & ~m)

@assert apply(read_mask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"), 11) == 73

function part1(data)
    mask = (0,0)
    mem = Dict{Int,Int}()
    for (cmd, x, y) in data
        if cmd == MASK
            mask = (x, y)
        else
            mem[x] = apply(mask, y)
        end
    end
    sum(values(mem))
end

@assert part1(td) == 165

data = read_data(read("input.txt", String))
println("PART1: ", part1(data))

# find location of 1 bits in the mask (the 'X's)
function mask_locs(m)
    n = count_ones(m)
    loc = zeros(Int, n)
    mm = m
    for i = 1:n
        t = trailing_zeros(mm)
        loc[i] = t
        mm &= ~(1<<t)  # zero it out for next iteration
    end
    loc
end
(tm,tv) = read_mask("000000000000000000000000000000X1001X")
@assert mask_locs(tm) == [0, 5]

getbit(a, n) = (a & (1<<n)) >> n
@assert getbit(7, 0) == 1
@assert getbit(16, 4) == 1
@assert getbit(8, 2) == 0

setbit(a, n, v) = (m = 1<<n; a & ~m | (v<<n) & m)

function mask_vals((m,v), x)
    r = []
    loc = mask_locs(m)
    n = length(loc)

    for i = 0:(1<<n-1)
        a = x | v
        for (j,o) in enumerate(loc)
            a = setbit(a, o, getbit(i, j-1))
        end
        push!(r, a)
    end
    r
end
@assert mask_vals((tm,tv), 42) == [26, 27, 58, 59]

function part2(data)
    mask = (0,0)
    mem = Dict{Int,Int}()
    for (cmd, x, y) in data
        if cmd == MASK
            mask = (x, y)
        else
            for a in mask_vals(mask, x)
                mem[a] = y
            end
        end
    end
    sum(values(mem))
end

#println(sum((2^count_ones(x)) for (cmd,x,y) in data if cmd == MASK))

ans = @time part2(data)
println("PART2: ", ans)

