ExUnit.start
defmodule Advent23.Test do
  use ExUnit.Case

  def move(nxt, ln) do
    cur = nxt[0]

    # pick up 3 and "remove" them
    n1 = nxt[cur]
    n2 = nxt[n1]
    n3 = nxt[n2]
    nxt = Map.put(nxt, cur, nxt[n3])
    #IO.puts "Picked up: #{n1} #{n2} #{n3}"

    # find next label down numerically as dest cup
    # as long as dest cup is not in the removed nodes
    dc = if cur > 1, do: cur - 1, else: ln
    dc =
      Stream.unfold(dc, fn dc -> {dc, (if dc > 1, do: dc - 1, else: ln)} end)
      |> Stream.drop_while(fn dc -> dc == n1 || dc == n2 || dc == n3 end)
      |> Enum.take(1)
      |> hd()
    #IO.puts "Destination: #{dc}"

    # put the removed cups clockwise of the destination cup
    nx = nxt[dc]
    nxt = Map.put(nxt, dc, n1)
    nxt = Map.put(nxt, n3, nx)

    #IO.puts "CUPS: #{n1} #{n2} #{n3} CUR: #{nxt[cur]}"
    # new current is one node clockwise of old current
    Map.put(nxt, 0, nxt[cur])
  end

  def nxt_to_list(nxt), do: nxt_to_list(nxt, nxt[0])
  def nxt_to_list(nxt, fst), do: nxt_to_list(nxt, fst, nxt[fst], [fst])
  def nxt_to_list(_nxt, fst, cur, rs) when cur == fst, do: Enum.reverse(rs)
  def nxt_to_list(nxt, fst, cur, rs), do: nxt_to_list(nxt, fst, nxt[cur], [cur | rs])

  def part1(cs, nmoves) do
    ln = length(cs)
    nxt = [0 | cs] ++ Enum.take(cs, 1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [k,v] -> {k,v} end)
    |> Enum.into(%{})

    nxt = Enum.reduce(1..nmoves, nxt, fn _n,nxt -> 
      move(nxt, ln) 
    end)

    nxt_to_list(nxt, 1)
    |> tl()
    |> Enum.join()
  end

  def part2(cs, nmoves) do
    ln = 1000000
    nxt = ([0 | cs] ++ Enum.to_list(10..1000000) ++ Enum.take(cs, 1))
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [k,v] -> {k,v} end)
    |> Enum.into(%{})

    nxt = Enum.reduce(1..nmoves, nxt, fn _n,nxt -> 
      #IO.write "Round #{n} "
      move(nxt, ln) 
    end)

    l1 = nxt[1]
    l2 = nxt[l1]
    IO.puts "l1: #{l1} l2: #{l2}"
    l1 * l2
  end

  test "test" do
    td = [3, 8, 9, 1, 2, 5, 4, 6, 7]
    assert part1(td, 10) == "92658374"
    assert part1(td, 100) == "67384529"
    data = [2, 1, 9, 7, 4, 8, 3, 6, 5]
    IO.puts "PART1: #{part1(data,100)}"

    #assert part2(td, 10000000) == 149245887792
    IO.inspect :timer.tc(fn -> part2(data, 10000000) end)
  end
end
