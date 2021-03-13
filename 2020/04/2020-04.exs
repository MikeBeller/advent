defmodule Advent04 do
  def test_data do
    ~S"""
    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    byr:1937 iyr:2017 cid:147 hgt:183cm

    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    hcl:#cfa07d byr:1929

    hcl:#ae17e1 iyr:2013
    eyr:2024
    ecl:brn pid:760753108 byr:1931
    hgt:179cm

    hcl:#cfa07d eyr:2025 pid:166559648
    iyr:2011 ecl:brn hgt:59in
    """
  end

  # turn the grid into a map of {r,c} => ?#  (or ?.)
  def string_to_map(s) do
    String.split(s)
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.map(fn [a,b] -> {String.to_atom(a), b} end)
    |> Enum.into(%{})
  end

  def read_data(inp) do
    String.trim(inp)
        |> String.split("\n\n")
        |> Enum.map(&string_to_map(&1))
  end

  @allkeys MapSet.new([:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid])

  def is_valid(pp) do
    keys = MapSet.new(Map.keys(pp)) |> MapSet.put(:cid)
    keys == @allkeys
  end

  def part1(data) do
    Enum.count(data, fn p -> is_valid(p) end)
  end
end


ExUnit.start
defmodule Advent.Test do
  use ExUnit.Case
  import Advent04

  test "test" do
    assert %{foo: "23", bar: "33", baz: "88"} = string_to_map("foo:23 bar:33\nbaz:88")
    td = read_data(test_data())
    assert length(td) == 4
    assert part1(td) == 2
    data = read_data(File.read!("input.txt"))
    IO.puts "PART1: #{part1(data)}"

    #IO.puts "PART2: #{part2(g,nr,nc,slopes)}"

  end
end
