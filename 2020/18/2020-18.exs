ExUnit.start()

defmodule Advent18.Test do
  use ExUnit.Case

  def td do
    [
      {"1 + 2 * 3 + 4 * 5 + 6", 71, 231},
      {"1 + (2 * 3) + (4 * (5 + 6))", 51, 51},
      {"2 * 3 + (4 * 5)", 26, 46},
      {"5 + (8 * 3 + 9 + 3 * 4 * 3)", 437, 1445},
      {"5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 12240, 669060},
      {"((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 13632, 23340},
      #{"7 * 2 * 7 * ((7 * 6 + 8 * 9) + 2)", 44296, 100},
    ]
  end

  def parse_expr(s, ts \\ [])
  def parse_expr("", ts), do: Enum.reverse(ts)
  def parse_expr(s, ts) do
    case s do
      <<?(, rest::binary>> -> parse_expr(rest, [:lpar | ts])
      <<?), rest::binary>> -> parse_expr(rest, [:rpar | ts])
      <<?*, rest::binary>> -> parse_expr(rest, [:mul | ts])
      <<?+, rest::binary>> -> parse_expr(rest, [:add | ts])
      <<?\s, rest::binary>> -> parse_expr(rest, ts)
      <<c, rest::binary>> when c >= ?0 and c <= ?9 ->
        parse_expr(rest, [c - ?0 | ts])
    end
  end

  def dijkstra(ts, prec, ops \\ [], out \\ [])
  def dijkstra([], _prec, ops, out), do: Enum.reverse(out) ++ ops
  def dijkstra([tok | ts], prec, ops, out) do
    case tok do
      :lpar -> dijkstra(ts, prec, [tok | ops], out)
      :rpar ->
        {xs, ops} = Enum.split_while(ops, fn t -> t != :lpar end)
        out = Enum.reverse(xs) ++ out
        ops = Enum.drop_while(ops, fn t -> t == :lpar end)
        dijkstra(ts, prec, ops, out)
      tok when tok == :add or tok == :mul ->
        {xs, ops} = Enum.split_while(ops, fn t -> (t == :add or t == :mul) and prec.(t) >= prec.(tok) end)
        out = Enum.reverse(xs) ++ out
        dijkstra(ts, prec, [tok | ops], out)
      n when n >= 0 and n <= 9 ->
        dijkstra(ts, prec, ops, [n | out])
    end
  end

  def eval(ts, st \\ [])
  def eval([], st), do: hd(st)
  def eval([tok | ts], st) do
    case tok do
      n when n >= 0 and n <= 9 -> eval(ts, [n | st])
      :add ->
        [a, b | st] = st
        eval(ts, [a + b | st])
      :mul ->
        [a, b | st] = st
        eval(ts, [a * b | st])
    end
  end

  def eval_expr(s, prec) do
    e = parse_expr(s)
    d = dijkstra(e, prec)
    IO.inspect {e,d}
    eval(d, prec)
  end

  def prec_none(_), do: 1
  def prec_normal(:add), do: 1
  def prec_normal(:mul), do: 0

  def eval_part1(s), do: eval_expr(s, &prec_none/1)
  def eval_part2(s), do: eval_expr(s, &prec_normal/1)

  def part1(ss) do
    ss
    |> Enum.map(&eval_part1/1)
    |> IO.inspect
    |> Enum.sum()
  end

  def part2(ss) do
    ss
    |> Enum.map(&eval_part2/1)
    |> Enum.sum()
  end

  test "test" do
    Enum.each(td(), fn {s, ans, _ans2} -> assert eval_part1(s) == ans end)

    data = File.read!("input.txt") |> String.trim |> String.split("\n")
    IO.puts "PART1: #{part1(data)}"

    Enum.each(td(), fn {s, _ans, ans2} -> assert eval_part2(s) == ans2 end)
    IO.puts "PART2: #{part2(data)}"
  end
end
