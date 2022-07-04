parse = fn x ->
  String.trim(x)
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)
end

{:ok, input} = File.read("input.txt")
data = parse.(input)

IO.inspect(data)

r1 =
  data
  |> Enum.chunk_every(2, 1, :discard)
  |> Enum.count(fn [x, y] -> y > x end)

IO.inspect(r1)
