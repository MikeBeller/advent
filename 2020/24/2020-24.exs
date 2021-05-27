ExUnit.start
defmodule Advent24.Test do
  use ExUnit.Case

  def test_data() do
    ~w(
    sesenwnenenewseeswwswswwnenewsewsw
    neeenesenwnwwswnenewnwwsewnenwseswesw
    seswneswswsenwwnwse
    nwnwneseeswswnenewneswwnewseswneseene
    swweswneswnenwsewnwneneseenw
    eesenwseswswnenwswnwnwsewwnwsene
    sewnenenenesenwsewnenwwwse
    wenwwweseeeweswwwnwwe
    wsweesenenewnwwnwsenewsenwwsesesenwne
    neeswseenwwswnwswswnw
    nenwswwsewswnenenewsenwsenwnesesenew
    enewnwewneswsewnwswenweswnenwsenwsw
    sweneswneswneneenwnewenewwneswswnese
    swwesenesewenwneswnwwneseswwne
    enesenwswwswneneswsenwnewswseenwsese
    wnwnesenesenenwwnenwsewesewsesesew
    nenewswnwewswnenesenwnesewesw
    eneswnwswnwsenenwnwnwwseeswneewsenese
    neswnwewnwnwseenwseesewsenwsweewe
    wseweeenwnesenwwwswnew
    )
  end

  def parse_dr(rs) do
    case rs do
      "" -> nil
        <<?n, ?w, rest::binary>> -> {:nw, rest}
        <<?n, ?e, rest::binary>> -> {:ne, rest}
        <<?s, ?w, rest::binary>> -> {:sw, rest}
        <<?s, ?e, rest::binary>> -> {:se, rest}
        <<?w, rest::binary>> -> {:w, rest}
        <<?e, rest::binary>> -> {:e, rest}
    end
  end

  def parse_rule(rs) do
    Stream.unfold(rs, &parse_dr(&1)) |> Enum.to_list
  end

  def move({x, y}, dr) do
    md = Bitwise.band(y, 1)
    case dr do
      :e -> {x + 1, y}
      :w -> {x - 1, y}
      :se when md == 0 -> {x, y + 1}
      :ne when md == 0 -> {x, y - 1}
      :sw when md == 0 -> {x - 1, y + 1}
      :nw when md == 0 -> {x - 1, y - 1}
      :se when md == 1 -> {x + 1, y + 1}
      :ne when md == 1 -> {x + 1, y - 1}
      :sw when md == 1 -> {x, y + 1}
      :nw when md == 1 -> {x, y - 1}
    end
  end

  def find(rule) do
    Enum.reduce(rule, {0, 0}, fn dr,pos -> move(pos, dr) end)
  end

  def flip(tiles, tl) do
    Map.update(tiles, tl, :black,
      fn
        :white -> :black
        :black -> :white
      end)
  end

  def count_black_tiles(tiles) do
    tiles
    |> Map.values()
    |> Enum.count(fn x -> x == :black end)
  end

  def part1(rules) do
    rules
    |> Enum.reduce(%{}, fn rule,tiles ->
      tl = find(rule)
      flip(tiles, tl)
    end)
    |> count_black_tiles()
  end

  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_rule(&1))
  end

  def all_neighbors(p) do
    [:e, :se, :sw, :w, :nw, :ne]
    |> Enum.map(&move(p, &1))
  end

  def num_bl_neighbors(tiles, p) do
    all_neighbors(p)
    |> Enum.count(fn p -> Map.get(tiles, p, :white) == :black end)
  end

  def life_step(tiles, p) do
    nn = num_bl_neighbors(tiles, p)
    c = Map.get(tiles, p, :white)
    case {c, nn} do
      {:black, n} when n == 1 or n == 2 -> {p, :black}
      {:black, _} -> {p, :white}
      {:white, 2} -> {p, :black}
      {:white, _} -> {p, :white}
    end
  end

  def life(tiles) do
    tiles
    |> Enum.filter(fn {_k,v} -> v == :black end)
    |> Enum.flat_map(fn {p,_v} -> all_neighbors(p) end)
    |> Enum.map(&life_step(tiles, &1))
    |> Enum.filter(fn {_p, v} -> v == :black end)
    |> Enum.into(%{})
  end

  def part2(rules, n) do
    start = 
      rules
      |> Enum.reduce(%{}, fn rule,tiles ->
        tl = find(rule)
        flip(tiles, tl)
      end)
    Enum.reduce(1..n, start,
      fn _day, tiles ->
        tiles = life(tiles)
        #IO.puts "DAY: #{day} COUNT: #{count_black_tiles(tiles)}"
        tiles
      end)
      |> count_black_tiles()
  end

  test "test" do
    td = test_data() |> Enum.map(&parse_rule(&1))
    assert find(parse_rule("nwwswee")) == {0, 0}
    assert part1(td) == 10
    data = read_data()
    IO.puts "PART1: #{part1(data)}"

    assert part2(td, 100) == 2208

    {tm,ans} =  :timer.tc(fn -> part2(data, 100) end)
    IO.puts "PART2: #{ans} TIME(us): #{tm}"
  end
end
