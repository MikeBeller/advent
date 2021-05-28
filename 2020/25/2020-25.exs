ExUnit.start
defmodule Advent25.Test do
  use ExUnit.Case
  @n 20201227
  @g 7

  def dh_seq(g, n), do: Stream.iterate(1, fn x -> rem(x * g, n) end)

  def find_exp(g, n, pk) do
    dh_seq(g, n)
    |> Enum.find_index(fn x -> x == pk end)
  end

  def modexp(a, b, n) do
    Enum.reduce(1..b, 1, fn _,x -> rem(x * a, n) end)
  end

  def part1(pkc, pkd) do
    #kc = find_exp(@g, @n, pkc)
    kd = find_exp(@g, @n, pkd)
    modexp(pkc, kd, @n)
  end

  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  test "test" do
    {pkc, pkd} = {5764801, 17807724}
    assert find_exp(@g, @n, pkc) == 8
    assert find_exp(@g, @n, pkd) == 11
    assert part1(pkc, pkd) == 14897079
    {pkc, pkd} = read_data()
    ans = part1(pkc, pkd)
    assert ans == part1(pkd, pkc)
    IO.puts "PART1: #{ans}"

  end
end
