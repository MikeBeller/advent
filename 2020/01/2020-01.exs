defmodule Advent01 do
  def test_data, do: [1721, 979, 366, 299, 675, 1456]
  def data, do: File.stream!("input.txt")
         |> Enum.map(&String.trim(&1))
         |> Enum.map(&String.to_integer(&1))

  # recursive implementation of all pairs -- for example only
  # since this would put all pairs in memory at once we use the
  # lazy version below
  def all_pairs(td), do: all_pairs(td, [])
  def all_pairs([],r), do: r
  def all_pairs([h | rest], r) do
    all_pairs(rest, (for t <- rest, do: {h,t} ) ++ r)
  end

  def all_pairs_stream(td) do
    Stream.unfold(td, fn
      [] -> nil
      [h | rest] -> {(for t <- rest, do: {h,t}), rest}
    end) |> Stream.concat
  end

  def part1(data) do
    {x,y} = all_pairs_stream(data)
            |> Stream.drop_while(fn {x,y} -> x + y != 2020 end)
            |> Enum.take(1)
            |> hd
    #IO.inspect {x,y}
    x * y
  end

  def all_triples(td) do
    Stream.unfold(td, fn
      [] -> nil
      [h | rest] -> {(for {y,z} <- all_pairs_stream(rest), do: {h,y,z}), rest}
    end) |> Stream.concat
  end

  def part2(data) do
    {x,y,z} = all_triples(data)
            |> Stream.drop_while(fn {x,y,z} -> x + y + z != 2020 end)
            |> Enum.take(1)
            |> hd
    #IO.inspect {x,y}
    x * y * z
  end
end


ExUnit.start
defmodule Advent.Test do
  use ExUnit.Case
  import Advent01

  test "test" do
    assert length(all_pairs(test_data())) == 15
    assert Enum.count(all_pairs_stream(test_data())) == 15
    assert part1(test_data()) == 514579, "part1"
    IO.puts "PART1: #{part1(data())}"

    assert Enum.count(all_triples(test_data())) == 20
    assert part2(test_data()) == 241861950, "part2"
    IO.puts "PART2: #{part2(data())}"
  end
end
