defmodule Advent02 do
  def test_data do
    ~S"""
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """
  end

  def read_data(inp) do
    String.trim(inp)
    |> String.split("\n")
    |> Enum.map(fn line ->
      [ss, es, c, pw] = Regex.run(~r/(\d+)-(\d+) (.): (.+)/,
        line, capture: :all_but_first)
      <<ch::utf8>> = c
      %{s: String.to_integer(ss), e: String.to_integer(es),
        c: ch, pw: pw} end)
  end

  def pw_ok(%{s: s, e: e, c: c, pw: pw}) do
    n = String.to_charlist(pw)
        |> Enum.count(fn x -> x == c end)
    n >= s and n <= e
  end
  def part1(data), do: Enum.count(data, &pw_ok(&1))

  def pw_ok2(%{s: s, e: e, c: c, pw: pw}) do
    ls = String.to_charlist(pw)
    a = if Enum.at(ls, s-1) == c, do: 1, else: 0
    b = if Enum.at(ls, e-1) == c, do: 1, else: 0
    a + b == 1
  end
  def part2(data), do: Enum.count(data, &pw_ok2(&1))
end


ExUnit.start
defmodule Advent.Test do
  use ExUnit.Case
  import Advent02

  test "test" do
    td = read_data(test_data())
    data = read_data(File.read!("input.txt"))

    assert length(td) == 3
    assert part1(td) == 2
    IO.puts "PART1: #{part1(data)}"

    assert part2(td) == 1, "part2"
    IO.puts "PART2: #{part2(data)}"
  end
end
