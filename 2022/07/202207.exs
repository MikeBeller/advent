defmodule Advent07 do
  def parse_cmd(cmd_str) do
    [cstr | rest] = String.split(cmd_str, "\n")
    case String.split(cstr, " ") do
      ["cd", dir] -> %{cmd: :cd, args: dir}
      ["ls"] -> %{cmd: :ls, args:
        (for line <- rest do
          case String.split(line)do
            ["dir", v] -> [v, 0]
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
    keys |> Enum.reduce(nodes, fn key, nodes ->
      case key do
        [_name | rest] ->
          Map.put(nodes, rest, nodes[key] + Map.get(nodes, rest, 0))
      end
    end)
  end

  def dir_sizes(input) do
    nodes = input
    |> apply_cmds()
    |> Map.get(:nodes)

    dir_keys = nodes |> Enum.filter(fn {_k,v} -> v == 0 end) |> Enum.map(fn {k,_v} -> k end)
    dir_keys = [["/"] | dir_keys ]

    nodes
    |> rollup()
    |> Map.take(dir_keys)
    |> Map.values()
  end

  def part1(input) do
    input
    |> dir_sizes()
    |> Enum.filter(&(&1 < 100000))
    |> Enum.sum()
  end

  def part2(input) do
    dsz = input
    |> dir_sizes()
    |> Enum.sort(:desc)
    |> IO.inspect()

  end
end

alias Advent07, as: A
tinput = A.parse_input(File.read!("tinput.txt"))
input = A.parse_input(File.read!("input.txt"))
95437 = A.part1(tinput)
IO.puts(A.part1(input))

IO.inspect(A.part2(tinput))
