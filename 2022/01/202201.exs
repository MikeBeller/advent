defmodule Advent01 do
  def parse(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn s -> s
        |> String.split("\n")
        |> Enum.map(&String.to_integer/1)
        end)
  end

  def part1(data) do
    data
    |> Enum.map(&Enum.sum/1)
    |> Enum.max()
  end

  def part2(data) do
    data
    |> Enum.map(&Enum.sum/1)
    # sort the sums in descending order, take the first 3, and add them
    |> Enum.sort(&>=/2)
    |> Enum.take(3)
    |> Enum.sum()
  end
end

input = File.read!("input.txt")
data = Advent01.parse(input)
IO.puts(Advent01.part1(data))

IO.puts(Advent01.part2(data))
