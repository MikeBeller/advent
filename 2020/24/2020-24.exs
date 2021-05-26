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

  def part1(rules) do
    rules
    |> Enum.reduce(%{}, fn rule,tiles ->
      tl = find(rule)
      flip(tiles, tl)
    end)
    |> Map.values()
    |> Enum.count(fn x -> x == :black end)
  end

  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_rule(&1))
  end

  test "test" do
    td = test_data() |> Enum.map(&parse_rule(&1))
    assert find(parse_rule("nwwswee")) == {0, 0}
    assert part1(td) == 10
    data = read_data()
    IO.puts "PART1: #{part1(data)}"

    #assert part2(td, 10000000) == 149245887792
    #{tm,ans} =  :timer.tc(fn -> part2(data, 10000000) end)
    #IO.puts "PART2: #{ans} TIME(us): #{tm}"
  end
end
