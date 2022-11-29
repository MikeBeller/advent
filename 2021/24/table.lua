require 'pl'
stringx.import()
lines = List(io.input("input.txt"):read("*a"):lines())

for r = 0,13 do
    for c = 0,17 do
        io.write(string.format("%10s ", lines[r*18 + c + 1]))
    end
    print()
end

