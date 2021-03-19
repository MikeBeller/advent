ExUnit.start
defmodule Advent08.Test do
  use ExUnit.Case
  def test_data do
    ~S"""
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
    """
  end

  def parse_inst(s) do
    [istr, nstr] = String.split(s, " ")
    {String.to_atom(istr), String.to_integer(nstr)}
  end

  def read_data(inp) do
    String.trim(inp)
    |> String.split("\n")
    |> Enum.map(&parse_inst(&1))
    |> Enum.with_index()
    |> Enum.map(fn {k,v} -> {v,k} end)
    |> Enum.into(%{})
  end

  def run(code, pc, acc, visited) do
    case visited[pc] do
      true -> {acc, pc}
      _ -> case code[pc] do
        {:nop, _n} -> run(code, pc+1, acc, Map.put(visited, pc, true))
        {:acc, n} -> run(code, pc+1, acc+n, Map.put(visited, pc, true))
        {:jmp, n} -> run(code, pc+n, acc, Map.put(visited, pc, true))
      end
    end
  end

  def part1(code) do
    {a,_p} = run(code, 0, 0, %{})
    a
  end

  def run_ok(code) do
    n = map_size(code)
    case run(code, 0, 0, %{n => true}) do
      {a, ^n} -> {:ok, a}
      {a, _} -> {:error, a}
    end
  end

  def tweak_inst(code, pc) do
    case code[pc] do
      {:nop, n} -> Map.put(code, pc, {:jmp, n})
      {:jmp, n} -> Map.put(code, pc, {:nop, n})
      _ -> code
    end
  end

  def part2(code) do
    {:ok, acc} = 0..map_size(code)
    |> Stream.map(fn i -> run_ok(tweak_inst(code, i)) end)
    |> Stream.drop_while(fn {k,_} -> k == :error end)
    |> Enum.take(1)
    |> hd
    acc
  end
    
  test "test" do
    td = read_data(test_data())
    assert part1(td) == 5
    data = read_data(File.read!("input.txt"))
    IO.puts "PART1: #{part1(data)}"
    IO.puts "PART2: #{part2(data)}"
  end
end
