ExUnit.start
defmodule Advent10.Test do
  use ExUnit.Case
  def test_data, do: "16 10 15 5 1 11 7 19 6 12 4"
  def test_data2, do: "28 33 18 42 31 14 46 20 48 47 24 23 49 45 19 38 39 11 1 32 25 35 8 17 7 9 4 2 34 10 3"

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

  def part2(data) do
    xs = [0 | data] |> Enum.sort() |> Enum.reverse()
    mx = hd xs
    {_n,s} = Enum.reduce(xs, [{mx+3, 1}],
      fn x,ls -> 
        #IO.puts "trying #{x} #{inspect ls}"
        sm = ls
        |> Enum.take_while(fn {n,_s} -> n - x <= 3 end)
        |> Enum.reduce(0, fn {_n,s},acc -> acc + s end)
        [{x, sm} | ls]
      end) |> hd()
    s
  end
    
  test "test" do
    td = read_data(test_data())
    td2 = read_data(test_data2())
    assert part1(td) == 35
    assert part1(td2) == 220
    data = read_data(File.read!("input.txt"))
    IO.puts part1(data)

    assert part2(td) == 8
    assert part2(td2) == 19208
    IO.puts "PART2: #{part2(data)}"
  end
end
