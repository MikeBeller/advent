defmodule Loop do
  def main(n) do
    1..(n - 1)
    |> Enum.sum()
  end
end

IO.puts(inspect(:timer.tc(fn -> Loop.main(1_000_000_000) end)))
