ExUnit.start
defmodule Advent23.Test do
  use ExUnit.Case

  # use maps
  #def make_nxt(kvs), do: Enum.into(kvs, %{})
  #def put(nxt, k, v), do: Map.put(nxt, k, v)
  #def get(nxt, k), do: nxt[k]

  # use arrays -- 40% reduction in runtime
  def make_nxt(kvs) do
    Enum.sort(kvs) |> :array.from_orddict()
  end
  def put(nxt, k, v), do: :array.set(k, v, nxt)
  def get(nxt, k), do: :array.get(k, nxt)

  def move(nxt, cur, ln) do
    # pick up 3 and "remove" them
    n1 = get(nxt, cur)
    n2 = get(nxt, n1)
    n3 = get(nxt, n2)
    nxt = put(nxt, cur, get(nxt, n3))

    # find next label down numerically as dest cup
    # as long as dest cup is not in the removed nodes
    dc = if cur > 1, do: cur - 1, else: ln
    dc =
      Stream.unfold(dc, fn dc -> {dc, (if dc > 1, do: dc - 1, else: ln)} end)
      |> Stream.drop_while(fn dc -> dc == n1 || dc == n2 || dc == n3 end)
      |> Enum.take(1)
      |> hd()

    # put the removed cups clockwise of the destination cup
    nx = get(nxt, dc)
    nxt = put(nxt, dc, n1)
    nxt = put(nxt, n3, nx)

    #IO.puts "CUPS: #{n1} #{n2} #{n3} CUR: #{nxt[cur]}"
    # new current is one node clockwise of old current
    {nxt, get(nxt, cur)}
  end

  def nxt_to_list(nxt, fst), do: nxt_to_list(nxt, fst, get(nxt, fst), [fst])
  def nxt_to_list(_nxt, fst, cur, rs) when cur == fst, do: Enum.reverse(rs)
  def nxt_to_list(nxt, fst, cur, rs), do: nxt_to_list(nxt, fst, get(nxt, cur), [cur | rs])

  def part1(cs, nmoves) do
    ln = length(cs)
    nxt = [0 | cs] ++ Enum.take(cs, 1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [k,v] -> {k,v} end)
    |> make_nxt()

    {nxt,_} = Enum.reduce(1..nmoves, {nxt,hd(cs)}, fn _n,{nxt,cur} -> 
      move(nxt, cur, ln) 
    end)

    nxt_to_list(nxt, 1)
    |> tl()
    |> Enum.join()
  end

  def part2(cs, nmoves) do
    ln = 1000000
    nxt = (cs ++ Enum.to_list(10..1000000) ++ Enum.take(cs, 1))
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [k,v] -> {k,v} end)
    |> make_nxt()

    {nxt,_cur} = Enum.reduce(1..nmoves, {nxt,hd(cs)}, fn _n,{nxt,cur} -> 
      #IO.write "Round #{n} "
      move(nxt, cur, ln) 
    end)

    l1 = get(nxt, 1)
    l2 = get(nxt, l1)
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
    {tm,ans} =  :timer.tc(fn -> part2(data, 10000000) end)
    IO.puts "PART2: #{ans} TIME(us): #{tm}"
  end
end
