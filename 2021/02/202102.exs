tds = """
forward 5
down 5
forward 8
up 3
down 8
forward 2
"""

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

IO.inspect(parse.(tds))
# {:ok, input} = File.read("input.txt")
# data = parse.(input)
