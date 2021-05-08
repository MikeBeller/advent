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

  def turn2(xw, yw, d) when d < 0, do: turn2(xw, yw, d + 360)
  def turn2(xw, yw, d) when rem(d, 90) == 0 do
    case d do
      0 -> {xw, yw}
      90 -> {-yw, xw}
      180 -> {-xw, -yw}
      270 -> {yw, -xw}
    end
  end

  def step2({xs, ys, xw, yw}, cmd) do
    case cmd do
      {?N, n} -> {xs, ys, xw, yw - n}
      {?S, n} -> {xs, ys, xw, yw + n}
      {?E, n} -> {xs, ys, xw + n, yw}
      {?W, n} -> {xs, ys, xw - n, yw}
      {?L, n} ->
        {xw, yw} = turn2(xw, yw, -n)
        {xs, ys, xw, yw}
      {?R, n} ->
        {xw, yw} = turn2(xw, yw, n)
        {xs, ys, xw, yw}
      {?F, n} ->
        {xs + n * xw, ys + n * yw, xw, yw}
    end
  end

  def part2(cmds) do
    {xs, ys, _xw, _yw} = Enum.reduce(cmds, {0, 0, 10, -1}, &step2(&2, &1))
    abs(xs) + abs(ys)
  end

  test "test" do
    td = read_data(@test_data)
    assert part1(td) == 25
    data = read_data(File.read!("input.txt") |> String.split())
    IO.puts "PART1: #{part1(data)}"

    assert part2(td) == 286
    IO.puts "PART2: #{part2(data)}"
  end
end
