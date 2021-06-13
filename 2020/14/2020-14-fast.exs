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

  def run_cmd({:mask, new_mask}, {_mask, mem}), do: {new_mask, mem}
  def run_cmd({:mem, {l, r}}, {mask, mem}), do: {mask, Map.put(mem, l, apply_mask(mask, r))}

  def part1(data) do
    {_m, mem} = data
    |> Enum.reduce({0, %{}}, &run_cmd/2)
    mem
    |> Map.values
    |> Enum.sum
  end

  def get_bit(n, i), do: (1 &&& (n >>> i))
  def set_bit(n, i, 0), do: (n &&& ~~~(1 <<< i))
  def set_bit(n, i, 1), do: (n ||| (1 <<< i))
  def bit_locs(n) do
    for i <- 0..35, get_bit(n, i) != 0, do: i
  end

  def masked_val({_m, v, bs, _n}, x, c) do
    r = x ||| v
    for {b,i} <- Enum.with_index(bs), reduce: r do
      r -> set_bit(r, b, get_bit(c, i))
    end
  end

  def masked_vals({_m, _v, _bs, n} = mask, x) do
    nc = 1 <<< n
    for i <- 0..(nc-1), do: masked_val(mask, x, i)
  end

  def enrich_mask({m, v}) do
    bs = bit_locs(m)
    n = length(bs)
    {m, v, bs, n}
  end
  def run_cmd_2({:mask, {m, v}}, {_mask, mem}), do: {enrich_mask({m, v}), mem}

  def run_cmd_2({:mem, {l, r}}, {mask, mem}) do
    mem = masked_vals(mask, l)
    |> Enum.reduce(mem, fn addr,mem -> Map.put(mem, addr, r) end)
    {mask, mem}
  end

  def part2(data) do
    {_m, mem} = data
    |> Enum.reduce({0, %{}}, &run_cmd_2/2)
    mem
    |> Map.values
    |> Enum.sum
  end

  test "test" do
    td = parse_data(@test_input)
    assert part1(td) == 165
    data = File.read!("input.txt") |> parse_data
    IO.puts "PART1: #{part1(data)}"

    tm = parse_mask("000000000000000000000000000000X1001X")
    assert masked_vals(enrich_mask(tm), 42) == [26, 27, 58, 59]
    {tm, ans} = :timer.tc( fn -> part2(data) end)
    IO.puts "PART2: #{ans} TIME: #{tm}"
  end
end
