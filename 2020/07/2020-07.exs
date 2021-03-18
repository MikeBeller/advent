defmodule Advent07 do
  def test_data do
    ~S"""
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    """
  end

  def parse_rule(s) do
    rr = Regex.scan(~r/(\d+ )?(\w+ \w+) bag/, s, capture: :all_but_first)
    ["", main_color] = hd rr
    kids = case tl rr do
      [["", "no other"]] -> []
      ls -> for [num_str, color_name] <- ls, do:
        {color_name, String.to_integer(String.trim(num_str))}
    end
    {main_color, kids}
  end

  def read_data(inp) do
    String.trim(inp)
    |> String.split("\n")
    |> Enum.map(&parse_rule(&1))
    |> Enum.into(%{})
  end

  def ibg(rr, c) do
    fs = Map.get(rr, c, [])
    [c | Enum.flat_map(fs, &ibg(rr, &1))]
  end

  def part1(rules) do
    rr = for {c,kids} <- rules, {kc,_n} <- kids, reduce: %{} do
      acc -> Map.update(acc, kc, [c], &[c | &1])
    end
    length(Enum.uniq(ibg(rr, "shiny gold"))) - 1
  end

  def nbg(rules, mult, col) do
    mult +
      Enum.sum(for {c,n} <- rules[col], do: nbg(rules, n*mult, c))
  end

  def part2(rules), do: nbg(rules, 1, "shiny gold") - 1
end

ExUnit.start
defmodule Advent.Test do
  use ExUnit.Case
  import Advent07

  test "test" do
    td = read_data(test_data())
    data = read_data(File.read!("input.txt"))
    assert part1(td) == 4
    IO.puts "PART1: #{part1(data)}"
    IO.puts "PART2: #{part2(data)}"
  end
end
