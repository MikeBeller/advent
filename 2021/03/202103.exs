defmodule M do
  def parse(s) do
    String.split(s, "\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def btoi(ls) do
    Enum.reduce(ls, fn d, acc -> 2 * acc + d end)
  end

  def part1(ys) do
    n_items = Enum.count(ys)
    columns = Enum.zip(ys)
    column_sums = Enum.map(columns, &Tuple.sum/1)
    gamma_rate = Enum.map(column_sums, fn x -> if x > n_items / 2, do: 1, else: 0 end)
    epsilon_rate = Enum.map(gamma_rate, fn d -> if d == 1, do: 0, else: 1 end)

    btoi(gamma_rate) * btoi(epsilon_rate)
  end

  def part2(ys) do
    o2rating = find1(ys, true)
    co2rating = find1(ys, false)
    btoi(o2rating) * btoi(co2rating)
  end

  def bit_criteria(ys, ox, i) do
    {count, sm} =
      ys
      |> Enum.map(fn y -> Enum.at(y, i) end)
      |> Enum.reduce({0, 0}, fn b, {c, s} -> {c + 1, s + b} end)

    n2 = count / 2
    mpb = if sm > n2, do: 1, else: 0

    if ox do
      if sm == n2, do: 1, else: mpb
    else
      if sm == n2, do: 0, else: 1 - mpb
    end
  end

  def find1(ys, ox, i \\ 0) do
    b = bit_criteria(ys, ox, i)
    nys = Enum.filter(ys, fn y -> Enum.at(y, i) == b end)
    # IO.puts("Bit #{i} Ox #{ox} selecting #{b} on list #{inspect(ys)}")

    case nys do
      [n] -> n
      _ -> find1(nys, ox, i + 1)
    end
  end

  def bench(n, data) do
    Enum.each(1..n, fn _n -> part2(data) end)
  end
end

{:ok, input} = File.read("input.txt")

_td =
  M.parse("""
  00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010
  """)

data = M.parse(input)
# data = td

IO.puts("PART1: #{M.part1(data)}")
IO.puts("PART2: #{M.part2(data)}")

M.bench(1000, data)
