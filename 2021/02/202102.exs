# declare the atoms (for safety)
_cmds = %{forward: 1, down: 2, up: 3}

parse_cmd = fn s ->
  case String.split(s, " ") do
    [x, y] -> {String.to_existing_atom(x), String.to_integer(y)}
    _ -> {}
  end
end

parse = fn x ->
  String.trim(x)
  |> String.split("\n")
  |> Enum.map(parse_cmd)
end

{:ok, input} = File.read("input.txt")
data = parse.(input)

move = fn
  {:forward, num}, {p, d} -> {p + num, d}
  {:down, num}, {p, d} -> {p, d + num}
  {:up, num}, {p, d} -> {p, d - num}
end

{p, d} = Enum.reduce(data, {0, 0}, move)

IO.puts("PART1: #{p * d}")

move2 = fn
  {:forward, num}, {p, d, a} -> {p + num, d + a * num, a}
  {:down, num}, {p, d, a} -> {p, d, a + num}
  {:up, num}, {p, d, a} -> {p, d, a - num}
end

{p, d, _a} = Enum.reduce(data, {0, 0, 0}, move2)

IO.puts("PART2: #{p * d}")
