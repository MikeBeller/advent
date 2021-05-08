ExUnit.start
defmodule Advent12.Test do
  use ExUnit.Case
  @test_data ~w(F10 N3 F7 R90 F11)

  def read_data(inp) do
    for <<c, rest::binary>> <- inp, do: {c, String.to_integer(rest)}
  end

  def turn(d, n) when rem(n, 90) == 0 do
    d = rem(d + n, 360)
    if d < 0, do: d + 360, else: d
  end

  def step({x, y, d}, cmd) do
    case cmd do
      {?N, n} -> {x, y-n, d}
      {?S, n} -> {x, y+n, d}
      {?E, n} -> {x+n, y, d}
      {?W, n} -> {x-n, y, d}
      {?L, n} -> {x, y, turn(d, -n)}
      {?R, n} -> {x, y, turn(d, n)}
      {?F, n} ->
        case d do
          90 -> {x + n, y, d}
          180 -> {x, y + n, d}
          270 -> {x - n, y, d}
          0 -> {x, y - n, d}
        end
    end
  end

  def part1(cmds) do
    {x, y, _d} = Enum.reduce(cmds, {0, 0, 90}, &step(&2, &1))
    abs(x) + abs(y)
  end

  test "test" do
    td = read_data(@test_data)
    assert part1(td) == 25
    data = read_data(File.read!("input.txt") |> String.split())
    IO.puts "PART1: #{part1(data)}"

    #assert part2(td) == 8
    #assert part2(td2) == 19208
    #IO.puts "PART2: #{part2(data)}"
  end
end
