defmodule Advent09 do
  def parse_command(line) do
    [command, value] = String.split(line, " ")
    {String.to_atom(command), String.to_integer(value)}
  end

  def read_data(fpath) do
    input = File.stream!(fpath)
      |> Enum.map(&parse_command/1)
  end

  def touching({hr, hc}, {tr, tc}) do
    abs(hr - tr) + abs(hc - tc) <= 1
  end

  def catch_up({hr, hc}, {tr, tc}) do
    # if they are in the same row and more than 1 space apart, move the tail one step toward the head
    if hr == tr and abs(hc - tc) > 1 do
      if hc > tc do
        {tr, tc + 1}
      else
        {tr, tc - 1}
      end
    # if they are in the same column and more than 1 space apart, move the tail one step toward the head
    else if hc == tc and abs(hr - tr) > 1 do
      if hr > tr do
        {tr + 1, tc}
      else
        {tr - 1, tc}
      end
    # else if they are neither in the same row nor the same column, move the tail one step diagonally toward the head
    else
      if hr > tr do
        if hc > tc do
          {tr + 1, tc + 1}
        else
          {tr + 1, tc - 1}
        end
      else
        if hc > tc do
          {tr - 1, tc + 1}
        else
          {tr - 1, tc - 1}
        end
      end
    # else don't move the tail
    else
      {tr, tc}
    end
  end

  def move(dir, %{h: {hr, hc}, t: {tr, tc}, visited: visited} = state) do
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

  test "move" do
    assert move(:U, %{h: {0, 0}, t: {0, 0}, visited: MapSet.new()}) == %{h: {-1, 0}, t: {0, 0}, visited: MapSet.new([{0, 0}])}
    assert move(:R, %{h: {0, 0}, t: {0, 0}, visited: MapSet.new()}) == %{h: {0, 1}, t: {0, 0}, visited: MapSet.new([{0, 0}])}
    assert move(:D, %{h: {0, 0}, t: {0, 0}, visited: MapSet.new()}) == %{h: {1, 0}, t: {0, 0}, visited: MapSet.new([{0, 0}])}
    assert move(:L, %{h: {0, 0}, t: {0, 0}, visited: MapSet.new()}) == %{h: {0, -1}, t: {0, 0}, visited: MapSet.new([{0, 0}])}
  end
end
