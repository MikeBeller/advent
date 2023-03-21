defmodule Advent09 do
  def parse_command(line) do
    [command, value] = line |> String.trim() |> String.split(" ")
    {String.to_atom(command), String.to_integer(value)}
  end

  def read_data(fpath) do
    File.stream!(fpath)
      |> Enum.map(&parse_command/1)
  end

  def touching({hr, hc}, {tr, tc}) do
    abs(hr - tr) <= 1 and  abs(hc - tc) <= 1
  end

  def catch_up({hr, hc}, {tr, tc}) do
    cond do
      hr == tr and abs(hc - tc) == 2 ->
        {tr, tc + div(hc - tc, 2)}

      hc == tc and abs(hr - tr) == 2 ->
        {tr + div(hr - tr, 2), tc}

      hr != tr and hc != tc ->
        dr = div(hr - tr, abs(hr - tr))
        dc = div(hc - tc, abs(hc - tc))
        {tr + dr, tc + dc}

      true ->
        {tr, tc}
    end
  end

  def move(dir, %{h: {hr, hc}, t: {tr, tc}, visited: visited} = _state) do
    {hr, hc} = case dir do
      :U -> {hr - 1, hc}
      :R -> {hr, hc + 1}
      :D -> {hr + 1, hc}
      :L -> {hr, hc - 1}
    end

    {tr, tc} =
      if touching({hr, hc}, {tr, tc}) do
        {tr, tc}
      else
        catch_up({hr, hc}, {tr, tc})
      end

    visited = MapSet.put(visited, {tr, tc})

    %{h: {hr, hc}, t: {tr, tc}, visited: visited}
  end

  def process_command({dir, val}, state) do
    Enum.reduce(1..val, state, fn _,state -> move(dir, state) end)
  end

  def process_commands(commands) do
    Enum.reduce(commands, %{h: {0, 0}, t: {0, 0}, visited: MapSet.new()}, &process_command/2)
  end

  def part1(fpath) do
    commands = read_data(fpath)
    state = process_commands(commands)
    MapSet.size(state.visited)
  end
end

ExUnit.start()

defmodule AdventO9Test do
  use ExUnit.Case
  import Advent09

  test "parse_command" do
    assert parse_command("U 1") == {:U, 1}
    assert parse_command("R 2") == {:R, 2}
    assert parse_command("D 3") == {:D, 3}
    assert parse_command("L 4") == {:L, 4}
  end

  test "move touching" do
    assert move(:U, %{h: {0, 0}, t: {0, 0}, visited: MapSet.new()}) == %{h: {-1, 0}, t: {0, 0}, visited: MapSet.new([{0, 0}])}
    assert move(:R, %{h: {0, 0}, t: {0, 0}, visited: MapSet.new()}) == %{h: {0, 1}, t: {0, 0}, visited: MapSet.new([{0, 0}])}
    assert move(:D, %{h: {0, 0}, t: {0, 0}, visited: MapSet.new()}) == %{h: {1, 0}, t: {0, 0}, visited: MapSet.new([{0, 0}])}
    assert move(:L, %{h: {0, 0}, t: {0, 0}, visited: MapSet.new()}) == %{h: {0, -1}, t: {0, 0}, visited: MapSet.new([{0, 0}])}
  end

  test "move horizontal or vertical" do
    assert move(:R, %{h: {0, 1}, t: {0, 0}, visited: MapSet.new([{0, 0}])})
      == %{h: {0, 2}, t: {0, 1}, visited: MapSet.new([{0, 0}, {0, 1}])}
    assert move(:U, %{h: {-1, 0}, t: {0, 0}, visited: MapSet.new([{0, 0}])})
      == %{h: {-2, 0}, t: {-1, 0}, visited: MapSet.new([{0, 0}, {-1, 0}])}
  end

  test "move diagonal" do
    assert move(:D, %{h: {1, 1}, t: {0, 0}, visited: MapSet.new([{0, 0}])})
      == %{h: {2, 1}, t: {1, 1}, visited: MapSet.new([{0, 0}, {1, 1}])}
    assert move(:L, %{h: {1, -1}, t: {0, 0}, visited: MapSet.new([{0, 0}])})
      == %{h: {1, -2}, t: {1, -1}, visited: MapSet.new([{0, 0}, {1, -1}])}
  end

  test "tinput" do
    assert 13 == part1("tinput.txt")
  end
end

part1 = Advent09.part1("input.txt")
IO.puts("Part 1: #{part1}")
