# demonstrate elixir tests and code in same file
#
defmodule Testy do
  def hello() do
    "hello"
  end
end

ExUnit.start
defmodule Testy.Test do
  use ExUnit.Case
  test "hello" do
    assert Testy.hello() == "hello"
  end

  #doctest Testy, import: true -- doesn't work unless you elixirc first
end
