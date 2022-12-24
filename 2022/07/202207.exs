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
    |> String.split("$ ")
    |> Enum.slice(1..-1)
    |> Enum.map(&parse_cmd/1)
  end
end

tinput = Advent07.parse_input(File.read!("tinput.txt"))
IO.inspect(tinput)
