ExUnit.start

defmodule Advent14.Test do
  use ExUnit.Case
  use Bitwise, only_operators: true

  @test_input ~S"""
  mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
  mem[8] = 11
  mem[7] = 101
  mem[8] = 0
  """

  def parse_mask(mask) do
    for <<c <- mask>>, reduce: {0,0} do
      {m, v} ->
        case c do
          ?X -> {2*m + 1, 2*v}
          ?0 -> {2*m, 2*v + 0}
          ?1 -> {2*m, 2*v + 1}
        end
    end
  end

  def parse_line(line) do
    case line do
      <<"mask = "::binary, rest::binary>> ->
        {:mask, parse_mask(rest)}
      <<"mem"::binary, rest::binary>> -> 
        [_m, l, r] = Regex.run(~r/\[(\d+)\] = (\d+)/, rest)
        {:mem, {String.to_integer(l), String.to_integer(r)}}
    end
  end

  def parse_data(s) do
    s
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn x -> parse_line(x) end)
  end

  def apply_mask({m,v}, x), do: (x &&& m) ||| (v &&& (~~~m))

  def run_cmd({:mask, mc}, {_m, mem}), do: {mc, mem}
  def run_cmd({:mem, {l, r}}, {m, mem}), do: {m, Map.put(mem, l, apply_mask(m, r))}

  def part1(data) do
    {_m, mem} = data
    |> Enum.reduce({0, %{}}, &run_cmd/2)
    mem
    |> Map.values
    |> Enum.sum
  end

  test "test" do
    td = parse_data(@test_input)
    assert part1(td) == 165
    data = File.read!("input.txt") |> parse_data
    IO.puts "PART1: #{part1(data)}"
  end
end
