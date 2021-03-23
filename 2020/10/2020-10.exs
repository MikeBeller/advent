ExUnit.start
defmodule Advent10.Test do
  use ExUnit.Case
  def test_data1, do: "16 10 15 5 1 11 7 19 6 12 4"

  def read_data(inp) do
    String.trim(inp)
    |> String.split(~r/[ \n]/)
    |> Enum.map(&String.to_integer(&1))
  end

  def part1(data) do
    xs = [0 | data] |> Enum.sort()
    cs = Enum.zip(xs, (tl xs))
         |> Enum.map(fn {a,b} -> b - a end)
         |> Enum.frequencies()
    cs[1] * (cs[3] + 1)
  end
    
  test "test" do
    td = read_data(test_data1())
    assert part1(td) == 35
    data = read_data(File.read!("input.txt"))
    #{us,r} = :timer.tc(fn -> part1(data, 5) end, [])
    IO.puts part1(data)

    #{us,r2} = :timer.tc(Advent10.Test, :part2, [data, r])
    #IO.puts "PART2: #{r2} TIME: #{us} us"
  end
end
