defmodule M do
  def parse(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def cost(xs, p) do
    xs
    |> Enum.map(fn x -> abs(x - p) end)
    |> Enum.sum()
  end

  def part1(xs) do
    {min, max} = Enum.min_max(xs)

    min..max
    |> Enum.map(fn x -> {cost(xs, x), x} end)
    |> Enum.min_by(fn {c, _p} -> c end)
  end

  def cost2(xs, p) do
    xs
    |> Enum.map(fn x ->
      n = abs(x - p)
      div(n * (n + 1), 2)
    end)
    |> Enum.sum()
  end

  def part2(xs) do
    {min, max} = Enum.min_max(xs)

    min..max
    |> Enum.map(fn x -> {cost2(xs, x), x} end)
    |> Enum.min_by(fn {c, _p} -> c end)
  end
end

tinput = "16,1,2,0,4,2,7,1,2,14"
tdata = M.parse(tinput)
IO.inspect(M.part1(tdata))

input = File.read!("input.txt")
data = M.parse(input)
{fuel, _x} = M.part1(data)
IO.puts("PART1: #{fuel}")

{fuel2, _x} = M.part2(data)
IO.puts("PART2: #{fuel2}")
