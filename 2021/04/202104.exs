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

  def part1(draws, boards) do
    Enum.map(boards, fn board -> play(draws, board) end)
  end
end

{:ok, input} = File.read("tinput.txt")
{draws, boards} = M.parse(input)
IO.inspect(boards)
IO.inspect(M.part1(draws, boards))
