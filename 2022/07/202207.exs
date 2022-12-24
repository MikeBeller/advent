defmodule Advent07 do
  def parse_cmd(cmd_str) do
    [cstr | rest] = String.split(cmd_str, "\n")
    case String.split(cstr, " ") do
      ["cd", dir] -> %{cmd: :cd, args: dir}
      ["ls"] -> %{cmd: :ls, args:
        (for line <- rest, !String.starts_with?(line, "dir") do
          case String.split(line)do
            [k, v] -> [v, String.to_integer(k)]
          end
        end)
      }
    end
  end

  def parse_input(input) do
    input
    |> String.split("\n$ ")
    |> Enum.slice(1..-1)
    |> Enum.map(&parse_cmd/1)
  end

  def apply_cmd(cmd, %{path: path, nodes: nodes} = state) do
    case cmd do
      %{cmd: :cd, args: ".."} -> %{state | path: (tl path)}
      %{cmd: :cd, args: dir} -> %{state | path: [dir | path]}
      %{cmd: :ls, args: args} ->
        nodes =
          args
          |> Enum.reduce(nodes, fn [name, size], nodes ->
            Map.put(nodes, [name | path], size)
          end)

        %{state | nodes: nodes}
    end
  end

  def apply_cmds(cmds), do: cmds |> Enum.reduce(%{path: ["/"], nodes: %{}}, &apply_cmd/2)

  def rollup(nodes) do
    keys = Map.keys(nodes) |> Enum.sort_by(&length/1, :desc)
    IO.inspect(keys)
    keys |> Enum.reduce(%{}, fn key, acc ->
      case key do
        [name] -> Map.put(acc, name, nodes[key])
        [name | rest] ->
          Map.put(acc, name, nodes[key] + Map.get(acc, rest, 0))
      end
    end)
  end
end

alias Advent07, as: A
tinput = A.parse_input(File.read!("tinput.txt"))
#IO.inspect(tinput)
st = tinput |> A.apply_cmds()
IO.inspect(st)
IO.inspect(A.rollup(st.nodes))
