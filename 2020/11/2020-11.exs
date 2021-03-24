ExUnit.start
defmodule Advent11.Test do
  use ExUnit.Case
  def test_data do
    ~S"""
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    """
  end

  def read_data(inp) do
    String.trim(inp)
    |> String.split("\n")
    |> Enum.map(&to_charlist(&1))
    |> Enum.with_index()
  end

  def part1(data) do
  end

  def part2(data) do
  end
    
  test "test" do
    td = read_data(test_data())
    IO.inspect td
    #assert part1(td) == 35
    #data = read_data(File.read!("input.txt"))
    #IO.puts "PART1: #{part1(data)}"

    #assert part2(td) == 8
    #assert part2(td2) == 19208
    #IO.puts "PART2: #{part2(data)}"
  end
end
