
function nadj(gr::Array{Char, 2}, r::Int, c::Int)
    n = 0
    for rr in (r-1):(r+1)
        if rr >= 1 && rr <= 5
            for cc in (c-1):(c+1)
                if cc >= 1 && cc <= 5
                    if gr[rr, cc] == '#'
                        n += 1
                    end
                end
            end
        end
    end
    n
end

function step(gr::Array{Char, 2})
    gr2 = similar(gr)
    for r in 1:5
        for c in 1:5
            v = gr[r, c]
            n = nadj(gr, r, c)
            if v == '#' && n != 1
                gr2[r, c] = '.'
            elseif v == '.' && (n == 1 || n == 2)
                gr2[r, c] = '#'
            else
                gr2[r, c] = v
            end
        end
    end
    gr2
end

function to_grid(s)
    lines = split(s, "\n")
    @assert length(lines) == 5
    gr = Array{Char,2}(undef, (5,5))
    for r in 1:5
        for c in 1:5
            gr[r, c] = lines[r][c]
        end
    end
    gr
end

function to_string(gr::Array{Char,2})
    join([join(gr[i,:]) for i in 1:5], "\n")
end


function test1()
    st = """
    ....#
    #..#.
    #..##
    ..#..
    #...."""
    print(st)
    gr = to_grid(st)
    print(gr)
    print(to_string(gr))
end

test1()

