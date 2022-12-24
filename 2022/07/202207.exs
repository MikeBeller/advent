defmodule Advent07 do
  def parse_cmd(cmd_str) do
    [cstr | rest] = String.split(cmd_str, "\n")
    case String.split(cstr, " ") do
      ["cd", dir] -> %{cmd: :cd, args: dir}
      ["ls"] -> %{cmd: :ls, args: (for line <- rest, do: String.split(line, " "))}
    end
  end

  def parse_input(input) do
    input
    |> String.split("\n?$ ")
    |> Enum.slice(1..-1)
    |> Enum.map(&parse_cmd/1)
  end

  def apply_cmd(cmd, %{path: path, nodes: nodes} = state) do
    case cmd do
      %{cmd: :cd, args: ".."} -> %{state | path: Enum.take(path, -1)}
      %{cmd: :cd, args: dir} -> %{state | path: path ++ [dir]}
      %{cmd: :ls, args: args} -> IO.inspect(args); state
    end
  end
end


tinput = Advent07.parse_input(File.read!("tinput.txt"))
IO.inspect(tinput)
IO.inspect(tinput |> Enum.reduce(%{path: [], nodes: []}, &Advent07.apply_cmd/2))
