defmodule M do
  def parse_board(s) do
    for {line, r} <- Enum.with_index(String.split(s, "\n", trim: true)),
        {n, c} <-
          Enum.with_index(
            String.split(line)
            |> Enum.map(&String.to_integer/1)
          ),
        into: Map.new() do
      {{r, c}, n}
    end
  end

  def parse(input) do
    [ds | rs] = String.split(input, "\n\n", trim: true)
    draws = String.split(ds, ",") |> Enum.map(&String.to_integer/1)

    boards = Enum.map(rs, &parse_board/1)
    {draws, boards}
  end

  def find(draw, board) do
    Enum.find_value(board, fn
      {{r, c}, ^draw} -> {r, c}
      _ -> nil
    end)
  end

  def row_is_full(board, r) do
    for c <- 0..4 do
      board[{r, c}] < 0
    end
    |> Enum.all?()
  end

  def col_is_full(board, c) do
    for r <- 0..4 do
      board[{r, c}] < 0
    end
    |> Enum.all?()
  end

  def step(draw, board) do
    board = Map.update(board, :step, 0, &(&1 + 1))
    board = Map.put(board, :draw, draw)

    case find(draw, board) do
      {r, c} ->
        board = Map.put(board, {r, c}, -draw)

        if row_is_full(board, r) or col_is_full(board, c) do
          {:halt, Map.put(board, :win, true)}
        else
          {:cont, board}
        end

      _ ->
        {:cont, board}
    end
  end

  def play(draws, board) do
    Enum.reduce_while(draws, board, fn draw, board -> step(draw, board) end)
  end

  def score(board) do
    unmarked =
      Enum.map(board, fn
        {{_r, _c}, v} when v > 0 -> v
        _ -> 0
      end)
      |> Enum.sum()

    unmarked * board[:draw]
  end

  def part1(draws, boards) do
    Enum.map(boards, fn board -> play(draws, board) end)
    |> Enum.min_by(fn board -> Map.get(board, :step) end)
    |> score()
  end

  def part2(draws, boards) do
    Enum.map(boards, fn board -> play(draws, board) end)
    |> Enum.max_by(fn board -> Map.get(board, :step) end)
    |> score()
  end
end

# {:ok, input} = File.read("tinput.txt")
# {tdraws, tboards} = M.parse(input)
# IO.inspect(M.part1(tdraws, tboards))

{:ok, input} = File.read("input.txt")
{draws, boards} = M.parse(input)
IO.puts("PART1: #{M.part1(draws, boards)}")
IO.puts("PART2: #{M.part2(draws, boards)}")
