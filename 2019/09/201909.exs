ExUnit.start

defmodule Advent09 do
  use ExUnit.Case, async: false

  def part1(prog), do: Intcode.run_with_input(prog,[1])
  def part2(prog), do: Intcode.run_with_input(prog,[2])

  test "part1 and part2" do
    prog = File.read!("input.txt")
           |> String.trim()
           |> String.split(",")
           |> Enum.map(&String.to_integer(&1))

    IO.puts "PART1: #{inspect part1(prog)}"
    IO.puts "PART2: #{inspect part2(prog)}"
  end
end

