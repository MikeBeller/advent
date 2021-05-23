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
      |> Stream.take_while(fn dc -> dc != n1 && dc != n2 && dc != n3 end)
      |> Enum.take(1)
      |> hd()
    #IO.puts "Destination: #{dc}"

    # put the removed cups clockwise of the destination cup
    nx = nxt[dc]
    nxt = Map.put(nxt, dc, n1)
    nxt = Map.put(nxt, n3, nx)

    # new current is one node clockwise of old current
    Map.put(nxt, 0, nxt[cur])
  end

  def nxt_to_list(nxt), do: nxt_to_list(nxt, nxt[0], nxt[nxt[0]], [nxt[0]])
  def nxt_to_list(_nxt, fst, cur, rs) when cur == fst, do: Enum.reverse(rs)
  def nxt_to_list(nxt, fst, cur, rs), do: nxt_to_list(nxt, fst, nxt[cur], [cur | rs])

  def part1(cs, nmoves) do
    ln = length(cs)
    nxt = [0 | cs] ++ Enum.take(cs, 1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [k,v] -> {k,v} end)
    |> Enum.into(%{})

    #IO.inspect nxt
    nxt = Enum.reduce(1..nmoves, nxt, fn _,nxt -> move(nxt, ln) end)
    #IO.inspect nxt

    nxt_to_list(nxt)
  end

  test "test" do
    td = [3, 8, 9, 1, 2, 5, 4, 6, 7]
    IO.inspect part1(td, 100)
    #data = read_data(File.read!("input.txt") |> String.split())
    #IO.puts "PART1: #{part1(data)}"

    #assert part2(td) == 286
    #IO.puts "PART2: #{part2(data)}"
  end
end
