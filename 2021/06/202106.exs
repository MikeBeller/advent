defmodule M do
  def parse(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def step(m) do
    nnf = Map.get(m, 0, 0)

    m
    |> Enum.map(fn {k, n} -> {k - 1, n} end)
    |> Enum.into(%{})
    |> Map.update(6, nnf, &(&1 + nnf))
    |> Map.put(8, nnf)
    |> Map.delete(-1)
  end

  def part1(data, ndays) do
    m = Enum.frequencies(data)
    m2 = Enum.reduce(1..ndays, m, fn _, acc -> step(acc) end)
    Map.values(m2) |> Enum.sum()
  end
end

tdata = [3, 4, 3, 1, 2]
IO.inspect(M.part1(tdata, 18))

data = File.read!("input.txt") |> M.parse()
IO.puts("PART1: #{M.part1(data, 80)}")
IO.puts("PART1: #{M.part1(data, 256)}")
