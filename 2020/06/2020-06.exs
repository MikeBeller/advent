defmodule Advent06 do
  def test_data, do: "abc||a|b|c||ab|ac||a|a|a|a||b" |> String.replace("|","\n")

  def read_data(inp) do
    for grs <- String.trim(inp) |> String.split("\n\n"), do:
      for rs <- String.split(grs, "\n"), do:
        String.to_charlist(rs) |> MapSet.new()
  end

  def part1(data) do
    group_anys = for g <- data, do: Enum.reduce(g, &MapSet.union(&1,&2))
    Enum.sum(for ga <- group_anys, do: MapSet.size(ga))
  end

  def part2(data) do
    group_alls = for g <- data, do: Enum.reduce(g, &MapSet.intersection(&1,&2))
    Enum.sum(for ga <- group_alls, do: MapSet.size(ga))
  end
end

ExUnit.start
defmodule Advent.Test do
  use ExUnit.Case
  import Advent06

  test "test" do
    td = read_data(test_data())
    data = read_data(File.read!("input.txt"))
    assert part1(td) == 11
    IO.puts "PART1: #{part1(data)}"
    assert part2(td) == 6
    IO.puts "PART2: #{part2(data)}"
  end
end
