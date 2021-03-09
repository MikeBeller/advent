defmodule Advent03 do
  def test_data do
    ~S"""
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """
  end

  # turn the grid into a map of {r,c} => ?#  (or ?.)
  def read_data(inp) do
    g = String.trim(inp)
        |> String.split("\n")
        |> Enum.map(&String.to_charlist(&1))
        |> Enum.with_index()
        |> Enum.flat_map( fn ({row, r}) -> for {ch,c} <- Enum.with_index(row), do: {{r,c},ch} end)
        |> Enum.into(%{})

    nr = Enum.max(for {r,_c} <- Map.keys(g), do: r) + 1
    nc = Enum.max(for {_r,c} <- Map.keys(g), do: c) + 1
    {g, nr, nc}
  end

  def part1(g, nr, nc, dr, dc), do: part1(g, nr, nc, dr, dc, 0, 0, 0)
  def part1(_g, nr, _nc, _dr, _dc, r, _c, n) when r >= nr, do: n
  def part1(g, nr, nc, dr, dc, r, c, n) do
    n = if g[{r,c}] == ?#, do: n + 1, else: n
    part1(g, nr, nc, dr, dc, r + dr, rem(c+dc,nc), n)
  end

  def part2(g, nr, nc, deltas) do
    (for {dr,dc} <- deltas, do: part1(g, nr, nc, dr, dc))
    |> Enum.reduce(1, &*/2)
  end
end


ExUnit.start
defmodule Advent.Test do
  use ExUnit.Case
  import Advent03

  test "test" do
    {g,nr,nc} = read_data(test_data())
    assert nr == 11 and nc == 11
    assert g[{0,2}] == ?#
    assert part1(g, nr, nc, 1, 3) == 7
    slopes = [{1,1}, {1,3}, {1,5}, {1,7}, {2,1}]
    assert part2(g, nr, nc, slopes) == 336

    {g,nr,nc} = read_data(File.read!("input.txt"))
    IO.puts "PART1: #{part1(g,nr,nc,1,3)}"
    IO.puts "PART2: #{part2(g,nr,nc,slopes)}"

  end
end
