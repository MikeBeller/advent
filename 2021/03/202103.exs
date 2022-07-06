parse = fn s ->
  String.split(s, "\n", trim: true)
  |> Enum.map(fn line ->
    String.split(line, "", trim: true)
    |> Enum.map(&String.to_integer/1)
  end)
end

{:ok, input} = File.read("input.txt")
data = parse.(input)

n_items = Enum.count(data)
columns = Enum.zip(data)
column_sums = Enum.map(columns, &Tuple.sum/1)
gamma_rate = Enum.map(column_sums, fn x -> if x > n_items / 2, do: 1, else: 0 end)
epsilon_rate = Enum.map(gamma_rate, fn d -> if d == 1, do: 0, else: 1 end)

btoi = fn ls ->
  Enum.reduce(ls, fn d, acc -> 2 * acc + d end)
end

IO.puts("PART1: #{btoi.(gamma_rate) * btoi.(epsilon_rate)}")

filter_loop = fn {b, i}, ys ->
  nys = Enum.filter(ys, fn y -> Enum.at(y, i) == b end)

  case nys do
    [n] -> {:halt, n}
    _ -> {:cont, nys}
  end
end

find1 = fn ys, r ->
  Enum.with_index(r)
  |> Enum.reduce_while(ys, filter_loop)
end

part2 = fn ys, gr, er ->
  o2rating = find1.(ys, gr)
  co2rating = find1.(ys, er)
  btoi.(o2rating) * btoi.(co2rating)
end

IO.puts("PART2: #{part2.(data, gamma_rate, epsilon_rate)}")
