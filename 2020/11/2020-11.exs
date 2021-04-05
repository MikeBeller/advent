ExUnit.start
defmodule Advent11.Test do
  use ExUnit.Case
  def test_data do
    ~S"""
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    """
  end

  def read_data(inp) do
    for {line,r} <- String.split(inp) |> Enum.with_index(),
      {ch, c} <- String.to_charlist(line) |> Enum.with_index(),
      into: %{}, do: {{r,c}, ch}
  end

  def map_to_string(m) do
    for r <- 0..9 do
      (for c <- 0..9, into: [], do: m[{r,c}]) |> to_string()
    end |> Enum.join("\n")
  end

  def num_neighbors(m, r, c) do
    (for dr <- -1..1,
      dc <- -1..1,
      !(dr == 0 && dc == 0), do:
      Map.get(m, {r+dr,c+dc}, ?L)) |> Enum.count(&(&1 == ?#))
  end

  def one_gen({_, m}) do
    m2 = for {{r,c},v} <- m, into: %{} do
      nn = num_neighbors(m, r, c)
      v2 = cond do
        (v == ?L and nn == 0) -> ?#
        (v == ?# and nn >= 4) -> ?L
        true -> v
      end
      {{r,c},v2}
    end
    nc = Enum.count(m2, fn {k,v} -> v != m[k] end)
    {nc, m2}
  end

  def part1(data) do
    {_nc, m} = {1, data}
                |> Stream.iterate(fn {nc,m} -> one_gen({nc,m}) end)
                |> Enum.find(fn {nc,_nf} -> nc == 0 end)
    Map.values(m) |> Enum.count(fn c -> c == ?# end)
  end

  def part2(_data) do
  end

  test "test" do
    td = read_data(test_data())
    assert part1(td) == 37
    data = read_data(File.read!("input.txt"))
    IO.puts "PART1: #{part1(data)}"

    #assert part2(td) == 8
    #assert part2(td2) == 19208
    #IO.puts "PART2: #{part2(data)}"
  end
end
