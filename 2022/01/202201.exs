defmodule Advent01 do
  import Enum
  def parse(input) do
    input
    |> String.split("\n\n")
    |> map(fn s -> s
        |> String.split("\n")
        |> map(&String.to_integer/1)
      end)
  end

  def part1(data), do: data |> map(&sum/1) |> max()

  def part2(data), do: data |> map(&sum/1) |> sort(&>=/2) |> take(3) |> sum()
end

input = File.read!("input.txt")
data = Advent01.parse(input)
IO.puts(Advent01.part1(data))
IO.puts(Advent01.part2(data))
