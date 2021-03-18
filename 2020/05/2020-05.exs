defmodule Advent05 do
  def test_data do
    ~S"""
    BFFFBBFRRR
    FFFBBBFRRR
    BBFFBBFRLL
    """
  end

  def read_data(inp) do
    String.trim(inp)
        |> String.split("\n")
        |> Enum.map(&String.to_charlist(&1))
  end

  def cl_to_num(cl, _zero_char, one_char) do
    Enum.reduce(cl, 0, fn c,acc -> acc * 2 + (if c == one_char, do: 1, else: 0) end)
  end

  def decode(cl) do
    [rc, cc] = Enum.chunk_every(cl, 7)
    row = cl_to_num(rc, ?F, ?B)
    col = cl_to_num(cc, ?L, ?R)
    {row, col}
  end

  def part1(data) do
    data
    |> Enum.map(&decode(&1))
    |> Enum.map(fn {r,c} -> r * 8 + c end)
    |> Enum.max()
  end

  def part2(data) do
    r = data
    |> Enum.map(&decode(&1))
    |> Enum.map(fn {r,c} -> r * 8 + c end)
    |> Enum.sort()

    {a, _b} = Enum.zip(r, (tl r))
    |> Enum.drop_while(fn {a,b} -> b == a + 1 end)
    |> hd

    a + 1
  end
end


ExUnit.start
defmodule Advent.Test do
  use ExUnit.Case
  import Advent05

  test "test" do
    td = read_data(test_data())
    assert part1(td) == 820
    data = read_data(File.read!("input.txt"))
    IO.puts "PART1: #{part1(data)}"

    IO.puts "PART2: #{part2(data)}"
  end
end
