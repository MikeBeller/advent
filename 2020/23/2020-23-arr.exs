ExUnit.start
defmodule Advent23.Test do
  use ExUnit.Case

  def move(nxt, ln) do
    cur = :array.get(0, nxt)

    # pick up 3 and "remove" them
    n1 = :array.get(cur, nxt)
    n2 = :array.get(n1, nxt)
    n3 = :array.get(n2, nxt)
    n4 = :array.get(n3, nxt)
    nxt = :array.set(cur, n4, nxt)

    # find next label down numerically as dest cup
    # as long as dest cup is not in the removed nodes
    dc = if cur > 1, do: cur - 1, else: ln
    dc =
      Stream.unfold(dc, fn dc -> {dc, (if dc > 1, do: dc - 1, else: ln)} end)
      |> Stream.drop_while(fn dc -> dc == n1 || dc == n2 || dc == n3 end)
      |> Enum.take(1)
      |> hd()

    # put the removed cups clockwise of the destination cup
    nx = :array.get(dc, nxt)
    nxt = :array.set(dc, n1, nxt)
    nxt = :array.set(n3, nx, nxt)

    # new current is one node clockwise of old current
    nxc = :array.get(cur, nxt)
    IO.puts "CUPS: #{n1} #{n2} #{n3} CUR: #{nxc}"
    :array.set(0, nxc, nxt)
  end

  def part2(cs, nmoves) do
    #ln = 1000000
    ln = 10
    #nxt = ([0 | cs] ++ Enum.to_list(10..1000000) ++ Enum.take(cs, 1))
    nxt = ([0 | cs] ++ Enum.take(cs, 1))
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [k,v] -> {k,v} end)
    |> Enum.sort()
    |> IO.inspect
    |> :array.from_orddict()

    nxt = Enum.reduce(1..nmoves, nxt, fn n,nxt -> 
      IO.write "Round #{n} "
      move(nxt, ln) 
    end)

    l1 = :array.get(1, nxt)
    l2 = :array.get(l1, nxt)
    IO.puts "l1: #{l1} l2: #{l2}"
    l1 * l2
  end

  test "test" do
    td = [3, 8, 9, 1, 2, 5, 4, 6, 7]
    part2(td, 10)

    #assert part2(td, 10000000) == 149245887792
    #IO.inspect :timer.tc(fn -> part2(data, 10000000) end)
  end
end
