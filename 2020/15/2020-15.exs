ExUnit.start

defmodule Advent15.Test do
  use ExUnit.Case

  def run_turns(n, _mem, t, last) when t == n + 1, do: last
  def run_turns(n, mem, t, last) do
    new = case Map.get(mem, last, 0) do
      0 -> 0
      n -> t - 1 - n
    end
    #IO.puts "TURN #{t} last #{last} new #{new}"
    run_turns(n, Map.put(mem, last, t-1), t+1, new)
  end

  def part1(ns, nt) do
    ln = length(ns)
    st = List.last(ns)
    mem = ns
        |> Enum.with_index(fn e,i -> {e, i+1} end)
        |> Enum.into(%{})
    run_turns(nt, mem, ln+1, st)
  end

  test "test" do
    assert part1([0, 3, 6], 10) == 0
    assert part1([1, 3, 2], 2020) == 1
    assert part1([2, 1, 3], 2020) == 10
    assert part1([3, 1, 2], 2020) == 1836

    data = [0,14,6,20,1,4]
    IO.puts "PART1: #{part1(data, 2020)}"

    {tm, ans} = :timer.tc(fn -> part1(data, 30000000) end)
    IO.puts "PART2: #{ans} TIME: #{tm}"
  end
end

