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

  def invalid_pports do
    ~S"""
    eyr:1972 cid:100
    hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

    iyr:2019
    hcl:#602927 eyr:1967 hgt:170cm
    ecl:grn pid:012533040 byr:1946

    hcl:dab227 iyr:2012
    ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

    hgt:59cm ecl:zzz
    eyr:2038 hcl:74454a iyr:2023
    pid:3556412378 byr:2007
    """
  end

  def valid_pports do
    ~S"""
    pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
    hcl:#623a2f

    eyr:2029 ecl:blu cid:129 byr:1989
    iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

    hcl:#888785
    hgt:164cm byr:2001 iyr:2015 cid:88
    pid:545766238 ecl:hzl
    eyr:2022

    iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
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

  def mrange(a,b) do 
    fn v ->
      c = String.to_integer(v)
      c >= a && c <= b
    end
  end

  def valid_height(v) do
    cs = Regex.run(~r/(\d+)(cm|in)/, v)
    case cs do
      [_, ss, "in"] -> mrange(59, 76).(ss)
      [_, ss, "cm"] -> mrange(150, 193).(ss)
    end
  end

  def valid, do: %{
    byr: [~r/^\d{4}$/, mrange(1920,2002)],
    iyr: [~r/^\d{4}$/, mrange(2010, 2020)],
    eyr: [~r/^\d{4}$/, mrange(2020, 2030)],
    hgt: [~r/^(\d+cm)|(\d+in)$/, fn x -> valid_height(x) end],
    hcl: [~r/^#[0-9a-f]{6}$/],
    ecl: [~r/^(amb)|(blu)|(brn)|(gry)|(grn)|(hzl)|(oth)$/],
    pid: [~r/^\d{9}$/],
    cid: [~r//],
  }

  def validate_field(vfs, k, v) do
    [re | fs] = vfs[k]
    Regex.run(re, v) && Enum.all?(fs, fn f -> f.(v) end)
  end

  def is_valid2(validators, pp) do
    pp = Map.put(pp, :cid, "1")
    (MapSet.new(Map.keys(pp)) == @allkeys) &&
      Enum.all?(pp, fn {k,v} -> validate_field(validators, k, v) end)
  end

  def part2(data) do
    validators = valid()
    Enum.count(data, fn p -> is_valid2(validators, p) end)
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

    validators = valid()
    assert validate_field(validators, :byr, "2002")
    assert !validate_field(validators, :byr, "2003")
    ip = read_data(invalid_pports())
    assert part2(ip) == 0
    vp = read_data(valid_pports())
    assert part2(vp) == length(vp)
    IO.puts "PART2: #{part2(data)}"
  end
end
