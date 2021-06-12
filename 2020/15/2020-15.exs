ExUnit.start

defmodule Advent15.Test do
  use ExUnit.Case

  def turn(m, n, t) do
    case Map.get(m, n, 0) do
      0 -> 0
      n -> t - n
    end
  end

  def part1(ns, nt) do
    ln = length(ns)
    st = List.last(ns)
    m = ns
        |> Enum.with_index(fn e,i -> {i+1, e} end)
        |> Enum.into(%{})
    {v,_} = ln..nt
    |> Enum.reduce({st,m},
      fn t, {n,m} ->
        v = turn(m, n, t)
        IO.puts "TURN: #{t} #{n} -> #{v}"
        {v, Map.put(m, v, t)}
      end)
    v
  end

  test "test" do
    assert part1([0, 3, 6], 10) == 0
    assert part1([1, 3, 2], 2020) == 1
    assert part1([2, 1, 3], 2020) == 10
  end
end

