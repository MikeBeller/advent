ExUnit.start

defmodule Advent16.Test do
  use ExUnit.Case

  def td_string do 
    ~S"""
    class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50
    
    your ticket:
    7,1,14
    
    nearby tickets:
    7,3,47
    40,4,50
    55,2,20
    38,6,12```)
    """
  end

  test "test" do
    IO.inspect td_string() |> String.trim() |> String.split("\n")

    #IO.puts "PART1: #{part1(data, 2020)}"

    #{tm, ans} = :timer.tc(fn -> part1(data, 30000000) end)
    #IO.puts "PART2: #{ans} TIME: #{tm}"
  end
end

