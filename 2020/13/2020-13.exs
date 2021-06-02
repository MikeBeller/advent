ExUnit.start

defmodule Advent13.Test do
  use ExUnit.Case

  def read_data(inp) do
    [sts,r] = String.split(inp)
    ls = String.split(r, ",")
         |> Enum.map(fn "x" -> nil
           s -> String.to_integer(s)
         end)
    {String.to_integer(sts), ls}
  end

  def part1({st, buses}) do
    {bid, delay} = (for b <- buses, b != nil, do: {b - rem(st, b), b}) |> Enum.min
    bid * delay
  end

  def norm(x, b) when rem(x,b) < 0, do: rem(x,b) + b
  def norm(x, _b), do: x

  def part2({_st, buses}) do
    poly = for {b,i} <- Enum.with_index(buses), b != nil, do: {b,norm(-i,b)}
    {_m, r} = poly
             |> Enum.reduce(fn {b,i}, {m,r} ->
               r = Stream.iterate(r, fn x -> x + m end)
                   |> Enum.find(fn x -> rem(x,b) == i end)
               m = m * b
               {m, r}
             end)
    r
  end

  test "test" do
    td = read_data("939\n7,13,x,x,59,x,31,19")
    assert part1(td) == 295
    data = File.read!("input.txt") |> read_data
    IO.puts "PART1: #{part1(data)}"

    assert part2(td) == 1068781
    assert part2(read_data("0\n17,x,13,19")) == 3417
    assert part2(read_data("0\n1789,37,47,1889")) == 1202161486
    IO.puts "PART2: #{part2(data)}"
  end
end

