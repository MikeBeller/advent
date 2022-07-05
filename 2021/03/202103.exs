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
