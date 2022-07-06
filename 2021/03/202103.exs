parse = fn s ->
  String.split(s, "\n", trim: true)
  |> Enum.map(fn line ->
    String.split(line, "", trim: true)
    |> Enum.map(&String.to_integer/1)
  end)
end

{:ok, input} = File.read("input.txt")

td =
  parse.("""
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

_data = parse.(input)
data = td

n_items = Enum.count(data)
columns = Enum.zip(data)
column_sums = Enum.map(columns, &Tuple.sum/1)
gamma_rate = Enum.map(column_sums, fn x -> if x > n_items / 2, do: 1, else: 0 end)
epsilon_rate = Enum.map(gamma_rate, fn d -> if d == 1, do: 0, else: 1 end)

btoi = fn ls ->
  Enum.reduce(ls, fn d, acc -> 2 * acc + d end)
end

IO.puts("PART1: #{btoi.(gamma_rate) * btoi.(epsilon_rate)}")

defmodule M do
  def part2() do
    o2rating = find1.(ys)
    co2rating = find1.(ys)
    btoi.(o2rating) * btoi.(co2rating)
  end

  def find1(ys, i \\ 0) do
    # need to also do least popular
    b = most_popular_bit(ys, i)
    nys = Enum.filter(ys, fn y -> Enum.at(y, i) == b end)

    case nys do
      [n] -> n
      _ -> find1(nys, i + 1)
    end
  end
end

IO.puts("PART2: #{part2.(data)}")
