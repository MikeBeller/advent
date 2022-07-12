defmodule M do
  def point(s) do
    s
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def parse_line(s) do
    [l, r] = String.split(s, " -> ")
    [x1, y1] = point(l)
    [x2, y2] = point(r)
    {x1, y1, x2, y2}
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def part1(lines) do
    lines
    |> Enum.reduce(%{}, fn {x1, y1, x2, y2}, m ->
      cond do
        x1 == x2 ->
          Enum.reduce(y1..y2, m, fn y, m ->
            Map.update(m, {x1, y}, 1, &(&1 + 1))
          end)

        y1 == y2 ->
          Enum.reduce(x1..x2, m, fn x, m ->
            Map.update(m, {x, y1}, 1, &(&1 + 1))
          end)

        true ->
          m
      end
    end)
    |> Map.values()
    |> Enum.count(fn v -> v > 1 end)
  end
end

IO.inspect(M.parse_line("830,945 -> 830,210"))
tinput = File.read!("tinput.txt")
tdata = M.parse(tinput)
IO.inspect(M.part1(tdata))

input = File.read!("input.txt")
data = M.parse(input)
IO.puts("PART1: #{M.part1(data)}")
