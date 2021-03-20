ExUnit.start
defmodule Advent09.Test do
  use ExUnit.Case
  def test_data do
    "35 20 15 25 47 40 62 55 65 95 102 117 150 182 127 219 299 277 309 576"
    |> String.split(" ")
    |> Enum.map(&String.to_integer(&1))
  end

  def read_data(inp) do
    String.trim(inp)
    |> String.split("\n")
    |> Enum.map(&String.to_integer(&1))
  end

  def is_sum(s, t, m) do
    if s == t do
      false
    else
      d = (hd t) - (hd s)
      if Map.has_key?(m, d) do
        true
      else
        is_sum((tl s), t, m)
      end
    end
  end

  def p1(s, t, m) do
    if !is_sum(s, t, m) do
      hd t
    else
      # remove hd s from the map, and add hd t
      r = hd s
      mu = case Map.get(m, r) do
        1 -> Map.delete(m, r)
        n -> Map.put(m, r, n-1)
      end
      rr = hd t
      mu = Map.put(mu, rr, Map.get(m, rr, 0) + 1)
      p1((tl s), (tl t), mu)
    end
  end

  def part1(data,w) do
    s = data
    t = Enum.drop(data, w)
    m = Enum.reduce(Enum.take(s, w), %{}, fn v,m -> Map.put(m, v, Map.get(m, v, 0) + 1) end)
    p1(s, t, m)
  end

  def part2(_code) do
  end
    
  test "test" do
    td = test_data()
    assert part1(td, 5) == 127
    data = read_data(File.read!("input.txt"))
    #{us,r} = :timer.tc(fn -> part1(data, 5) end, [])
    {us,r} = :timer.tc(Advent09.Test, :part1, [data, 25])
    IO.puts "PART1: #{r} TIME: #{us} us"
    #IO.puts "PART2: #{part2(data)}"
  end
end
