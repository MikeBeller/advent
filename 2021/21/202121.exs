defmodule Advent21 do
  def parse(instr) do
    instr
    |> String.split("\n", parts: 2)
    |> Enum.map(fn s ->
      s |> String.split() |> List.last() |> String.to_integer()
    end)
    |> List.to_tuple()
  end

  def turn(p, s, nr, d) do
    np = rem(p + 3 * d + 3 - 1, 10) + 1
    {np, s + np, nr + 3, rem(d + 3 - 1, 100) + 1}
  end

  def play_game(p1, p2, s1, s2, nr, d) do
    {p1, s1, nr, d} = turn(p1, s1, nr, d)

    if s1 >= 1000 do
      s2 * nr
    else
      {p2, s2, nr, d} = turn(p2, s2, nr, d)

      if s2 >= 1000 do
        s1 * nr
      else
        play_game(p1, p2, s1, s2, nr, d)
      end
    end
  end

  def part1({p1, p2}) do
    play_game(p1, p2, 0, 0, 0, 1)
  end
end

tinput = Advent21.parse(File.read!("tinput.txt"))

739_785 = Advent21.part1(tinput)

input = Advent21.parse(File.read!("input.txt"))
ans1 = Advent21.part1(input)
IO.puts("PART1: #{ans1}")
