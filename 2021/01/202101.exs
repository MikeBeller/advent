parse = fn x ->
  String.trim(x)
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)
end

{:ok, input} = File.read("input.txt")
data = parse.(input)

# enum based solution to p1 (4 lines!)
r1 =
  data
  |> Enum.chunk_every(2, 1, :discard)
  |> Enum.count(fn [x, y] -> y > x end)

IO.puts("PART1: #{r1}")

# recursion based solution to p1
defmodule Main do
  def p1r(ls) do
    case ls do
      [] -> 0
      [_x] -> 0
      [x, y | tail] when y > x -> 1 + p1r([y | tail])
      [_x, y | tail] -> p1r([y | tail])
    end
  end
end

IO.puts("PART1 recursive: #{Main.p1r(data)}")

r2 =
  data
  |> Enum.chunk_every(3, 1, :discard)
  |> Enum.map(&Enum.sum/1)
  |> Enum.chunk_every(2, 1, :discard)
  |> Enum.count(fn [x, y] -> y > x end)

IO.puts("PART2: #{r2}")
